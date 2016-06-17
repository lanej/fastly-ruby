# frozen_string_literal: true
class Fastly::Real
  attr_reader :via, :logger, :adapter, :username, :password, :token, :url, :connection

  def initialize(options = {})
    @username, @password, @token, @url, @adapter, @logger =
      options.values_at(:username, :password, :token, :url, :adapter, :logger)

    if !(token || '').empty?
      @via = :token
    elsif (username || '').empty? && (password || '').empty?
      raise ArgumentError, 'missing token or [username, password]'
    else
      @via = :session
    end

    @url ||= 'https://api.fastly.com'
    @adapter ||= Faraday.default_adapter

    @connection = create_connection
  end

  private

  def create_connection
    Faraday.new(url: url) do |connection|
      # request
      connection.request :multipart

      if via == :session
        connection.use :cookie_jar
      else
        connection.use Fastly::TokenMiddleware, token
      end

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
