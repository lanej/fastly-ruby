# frozen_string_literal: true
module Fastly::Request
  class << self
    alias cistern_included included
  end

  def self.included(receiver)
    cistern_included(receiver)
    receiver.extend(ClassMethods)
    super
  end

  module ClassMethods
    def request_method(request_method = nil)
      @request_method ||= request_method
    end

    def request_params(&block)
      @request_params ||= block
    end

    def request_body(&block)
      @request_body ||= block
    end

    def request_path(&block)
      @request_path ||= block
    end

    def parameters
      @parameters ||= []
    end

    def parameter(name)
      parameters << name

      define_method(name) do
        val = instance_variable_get("@#{name}")
        val.nil? ? raise(ArgumentError, "#{name} is required") : val
      end
    end
  end

  attr_reader :params

  def setup(*args)
    if args.size > self.class.parameters.size
      raise ArgumentError, "too many arguments for parameters: #{self.class.parameters}"
    end

    args.each_with_index do |arg, i|
      instance_variable_set("@#{self.class.parameters[i]}", arg)
    end
  end

  def _mock(*args)
    setup(*args)
    mock
  end

  def _real(*args)
    setup(*args)
    real
  end

  def request_params
    if self.class.request_params
      self.class.request_params.call(self)
    else
      {}
    end
  end

  def request_path
    case (generator = self.class.request_path)
    when Proc then
      generator.call(self)
    else raise ArgumentError, "Couldn't generate request_path from #{generator.inspect}"
    end
  end

  def request_body
    case (generator = self.class.request_body)
    when Proc then
      generator.call(self)
    when NilClass then nil
    else raise("Invalid request body generator: #{generator.inspect}")
    end
  end

  def pluralize(word)
    pluralized = word.dup
    [[/y$/, 'ies'], [/$/, 's']].find { |regex, replace| pluralized.gsub!(regex, replace) if pluralized.match(regex) }
    pluralized
  end

  def url_for(path, options = {})
    URI.parse(
      File.join(cistern.url, path.to_s)
    ).tap do |uri|
      query = options[:query]

      if query && query.any?
        uri.query = Faraday::NestedParamsEncoder.encode(query)
      end
    end.to_s
  end

  def real(params = {})
    request(method: self.class.request_method,
            path: request_path,
            body: request_body,
            url: params['url'],
            params: request_params)
  end

  def real_request(params = {})
    request({
      method: self.class.request_method,
      path: request_path(params),
      body: request_body(params),
    }.merge(cistern.hash.slice(params, :method, :path, :body, :headers)))
  end

  def mock_response(body, options = {})
    response(
      method: self.class.request_method,
      path: options[:path] || request_path,
      request_body: request_body,
      response_body: body,
      headers: options[:headers] || {},
      status: options[:status]  || 200,
      params: options[:params]  || request_params
    )
  end

  def find!(collection, *identities, **_options)
    resource = cistern.data[collection].dig(*identities)
    return resource if resource

    identifier = identities.map(&:to_s).join(',')
    mock_response({
                    'msg' => 'Record not found',
                    'detail' => "Cannot find #{collection.to_s.capitalize} [#{identifier}]'",
                  }, { status: 404 })
  end

  def delete!(collection, *identities, **_options)
    found = cistern.data[collection].dig(*identities[0..-2]).delete(identities.last)
    found ? mock_response('status' => 'ok') : raise(NotImplementedError)
  end

  def request(options = {})
    method      = options[:method] || :get
    params      = options[:params] || {}
    body        = options[:body]

    path        = options[:path]
    request_url = options[:url] || url_for(path, query: params)

    headers     = {
      'User-Agent' => Fastly::USER_AGENT,
      'Accept'     => 'application/json',
    }.merge(options[:headers] || {})

    response = cistern.connection.send(method) do |req|
      req.url(request_url)
      req.headers.merge!(headers)
      req.params.merge!(params)
      req.body = body
    end

    Fastly::Response.new(
      status: response.status,
      headers: response.headers,
      body: response.body,
      request: {
        method: method,
        url: request_url,
        headers: headers,
        body: body,
        params: params,
      }
    ).raise!
  end

  def response(options = {})
    body   = options[:response_body] || options[:body]
    method = options[:method]        || :get
    params = options[:params]
    status = options[:status] || 200

    path        = options[:path]
    request_url = options[:url] || url_for(path, query: params)

    request_headers  = { 'Accept'       => 'application/json' }
    response_headers = { 'Content-Type' => 'application/json; charset=utf-8' }

    Fastly::Response.new(
      status: status,
      headers: response_headers,
      body: body,
      request: {
        method: method,
        url: request_url,
        headers: request_headers,
      }
    ).raise!
  end

  def updated_attributes
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(attributes), *self.class.accepted_parameters)
  end

  def timestamp
    Time.now.iso8601
  end
end
