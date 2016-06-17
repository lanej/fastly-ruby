# frozen_string_literal: true
class Fastly::Mock
  KEYSPACE = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).map(&:to_s)).freeze

  def self.data
    @data ||= Hash.new do |d, url|
      d[url] = {
        backends: Hash.new { |sv, s| sv[s] = Hash.new { |vb, b| vb[b] = {} } },
        customers: {},
        domains: Hash.new { |sv, s| sv[s] = Hash.new { |vb, b| vb[b] = {} } },
        service_versions: Hash.new { |sv, s| sv[s] = {} },
        services: {},
      }
    end
  end

  def self.reset
    data.clear
  end

  attr_reader :via, :logger, :adapter, :username, :password, :token, :url, :connection

  def initialize(options = {})
    @username, @password, @token, @url, @adapter, @logger =
      options.values_at(:username, :password, :token, :url, :adapter, :logger)

    @url ||= 'https://api.fastly.com'
  end

  attr_reader :current_customer_id

  def current_customer=(customer)
    @current_customer_id = customer.id
  end

  def current_customer
    customers.new(data[:customers].fetch(current_customer_id))
  end

  def data
    self.class.data[@url]
  end

  def reset
    data.clear
  end

  def new_id
    Array.new(21) { KEYSPACE[rand(KEYSPACE.size) + 1] }.join('')
  end
end
