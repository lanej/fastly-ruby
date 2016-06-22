# frozen_string_literal: true
module ServiceHelper
  class << self
    attr_accessor :example_services, :services
  end

  def self.reset
    self.example_services = services
  end

  def self.service(validate: ->(r) { r.reload.deleted_at.nil? })
    self.services = yield unless services&.any?
    self.example_services = services unless example_services&.any?

    valid_service = nil

    while example_services.any? && valid_service.nil?
      resource = example_services.sample

      example_services.delete(resource)

      valid_service = resource if validate.call(resource)
    end

    valid_service
  end

  def create_service(options = {})
    name = options.fetch(:name, SecureRandom.hex(8))

    client.services.create(name: name)
  end

  def a_backend(**options)
    version = options.delete(:version) || a_version(options)
    matching_backend = version.backends.find do |backend|
      options.all? { |k, v| v == backend.attributes[k] }
    end

    return matching_backend if matching_backend

    create_options = {
      hostname: "#{SecureRandom.hex(3)}.example-#{SecureRandom.hex(3)}.com",
      name: SecureRandom.hex(3),
      service_id: version.service_id,
      version_number: version.number,
    }.merge(options)

    version.backends.create(create_options)
  end

  def a_domain(**options)
    version = options.delete(:version) || a_version(options)
    matching_domain = version.domains.find do |domain|
      options.all? { |k, v| v == domain.attributes[k] }
    end

    return matching_domain if matching_domain

    create_options = {
      name: SecureRandom.hex(3),
      service_id: version.service_id,
      version_number: version.number,
    }.merge(options)

    version.domains.create(create_options)
  end

  def a_condition(**options)
    version = options.delete(:version) || a_version(options)
    matching_condition = version.conditions.find do |condition|
      options.all? { |k, v| v == condition.attributes[k] }
    end

    return matching_condition if matching_condition

    create_options = {
      service_id: service.id,
      version_number: version.number,
      name: SecureRandom.hex(3),
      type: 'CACHE',
      statement: 'req.url~+"index.html"',
      priority: 10,
    }.merge(options)

    version.conditions.create(create_options)
  end

  def a_dictionary(**options)
    version = options.delete(:version) || a_version(options)
    matching_dictionary = version.dictionaries.find do |dictionary|
      options.all? { |k, v| v == dictionary.attributes[k] }
    end

    return matching_dictionary if matching_dictionary

    create_options = {
      name: 'fst_' + SecureRandom.hex(3),
      service_id: version.service_id,
      version_number: version.number,
    }.merge(options)

    version.dictionaries.create(create_options)
  end

  def a_service(options = {})
    return create_service(options) if Fastly.mocking?
    cached_service = ServiceHelper.service { client.services.all }

    cached_service || create_service(options)
  end

  def a_version(service: a_service, **options)
    matching_version = service.versions.find do |version|
      options.all? { |k, v| v == version.attributes[k] }
    end
    matching_version || service.versions.create(options)
  end

  def viable_version(**options)
    service = options.delete(:service) || a_service

    existing_viable_version(service, options) || create_viable_version(service, options)
  end

  private

  def existing_viable_version(service, attributes)
    service.versions.find do |version|
      version.backends.any? && version.domains.any? && !version.locked? &&
        attributes.all? { |k, v| v == version.attributes[k] }
    end
  end

  def create_viable_version(service, attributes)
    attributes = attributes.dup

    version = service.versions.find { |v| !v.locked? } || service.versions.last.clone!
    version.backends.any? ||
      version.backends.create(name: service.name, hostname: "#{SecureRandom.hex(3)}.example.com")
    version.domains.any? ||
      version.domains.create(name: "#{SecureRandom.hex(3)}.example-#{SecureRandom.hex(3)}.com")

    activate = attributes.delete(:active)
    version.activate! if activate
    version.deactivate! if false == activate
    version.update(attributes) if attributes.any?

    version
  end
end

RSpec.configure do |config|
  config.include(ServiceHelper)
  config.before(:each) { ServiceHelper.reset unless Fastly.mocking? }
end
