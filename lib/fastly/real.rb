# frozen_string_literal: true
class Fastly::Real

  DEFAULT_URL = 'https://api.fastly.com'

  attr_reader :via, :logger, :adapter, :username, :password, :token, :url, :connection

  def initialize(options = {})
    @username, @password, @token, @url, @adapter, @logger =
      options.values_at(:username, :password, :token, :url, :adapter, :logger)

    @via = []

    @via << :token unless (token || '').empty?
    @via << :username unless (username || '').empty? && (password || '').empty?

    raise ArgumentError, 'missing token or [username, password]' if @via.empty?

    @url ||= DEFAULT_URL
    @adapter ||= Faraday.default_adapter

    @connection = create_connection
  end

  private

  def create_connection
    Faraday.new(url: url) do |connection|
      # request
      connection.request :multipart

      connection.use :cookie_jar if via.include?(:session)
      connection.use Fastly::TokenMiddleware, token if via.include?(:token)

      # idempotency
      connection.request :retry,
                         max: 30,
                         interval: 1,
                         interval_randomness: 0.2,
                         backoff_factor: 2

      connection.response :detailed_logger, logger if logger

      # response
      connection.response :json, content_type: /\bjson/

      connection.adapter(*adapter)
    end
  end
end
