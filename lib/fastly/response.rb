# frozen_string_literal: true
class Fastly::Response
  class Error < StandardError
    attr_reader :response
    attr_reader :msg
    attr_reader :detail

    def initialize(response)
      @response = response

      body = response.body

      if body
        @msg = body['msg']
        @detail = body['detail']
      end

      super(error_message)
    end

    private

    def error_message
      message = ''
      message += detail if detail
      message += if msg && !detail
                   msg
                 elsif msg
                   " [#{msg}]"
                 end
      message += "\n" unless message.empty?
      message += JSON.pretty_generate(
        status: response.status,
        headers: response.headers,
        body: response.body,
        request: response.request,
      )

      message
    end
  end

  BadRequest        = Class.new(Error)
  Conflict          = Class.new(Error)
  NotFound          = Class.new(Error)
  Forbidden         = Class.new(Error)
  RateLimitExceeded = Class.new(Error)
  Unauthorized      = Class.new(Error)
  Unexpected        = Class.new(Error)
  Unprocessable     = Class.new(Error)

  EXCEPTION_MAPPING = {
    400 => BadRequest,
    401 => Unauthorized,
    403 => Forbidden,
    404 => NotFound,
    409 => Conflict,
    422 => Unprocessable,
    429 => RateLimitExceeded,
    500 => Unexpected,
  }.freeze

  attr_reader :headers, :status, :body, :request

  def initialize(options = {})
    @status, @headers, @body, @request =
      options.values_at(:status, :headers, :body, :request)
  end

  def successful?
    status >= 200 && status <= 299 || status == 304
  end

  def raise!
    if !successful?
      klass = EXCEPTION_MAPPING[status] || Error
      raise klass, self
    else self
    end
  end
end
