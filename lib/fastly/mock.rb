# frozen_string_literal: true
class Fastly::Mock
  KEYSPACE = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

  def self.data
    @data ||= Hash.new do |d, url|
      d[url] = {
        backends: service_version_hash,
        conditions: service_version_hash,
        customers: {},
        dictionaries: service_version_hash,
        dictionary_items: service_version_hash,
        domains: service_version_hash,
        service_versions: Hash.new { |sv, s| sv[s] = {} },
        services: {},
      }
    end
  end

  def self.service_version_hash
    Hash.new { |sv, s| sv[s] = Hash.new { |vb, b| vb[b] = {} } }
  end

  private_class_method :service_version_hash

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
    base_16_id = SecureRandom.uuid.delete('-').to_i(16)

    id = []
    while base_16_id > 0
      id << KEYSPACE[base_16_id.modulo(62)]
      base_16_id /= 62
    end
    id.join
  end
end
