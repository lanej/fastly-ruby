module ServiceHelper
  class << self
    attr_accessor :example_services, :services
  end

  def self.reset
    self.example_services = self.services
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

  def create_service(options={})
    name = options.fetch(:name, SecureRandom.hex(8))

    client.services.create(name: name)
  end

  def a_service(options={})
    return create_service(options) if Fastly.mocking?
    cached_service = ServiceHelper.service { client.services.all }

    cached_service || create_service(options)
  end

  def a_version(**options)
    service = options.delete(:service) || a_service
    return service.versions.sample if options.empty?

    matching_version = service.versions.find do |version|
      options.all? { |k,v| v == version.attributes[k] }
    end
    matching_version || service.versions.create(options)
  end

  def viable_version(**options)
    service = options.delete(:service) || a_service

    matching_version = service.versions.find { |version|
      version.backends.any? && version.domains.any? && !version.locked? &&
        options.all? { |k,v| v == version.attributes[k] }
    }

    return matching_version if matching_version

    version = service.versions.find { |v| !v.locked? } || service.versions.last.clone!
    version.backends.any? ||
      version.backends.create(name: service.name, hostname: "#{SecureRandom.hex(3)}.example.com")
    version.domains.any? ||
      version.domains.create(name: "#{SecureRandom.hex(3)}.example-#{SecureRandom.hex(3)}.com")

    activate = options.delete(:active)
    version.activate! if activate
    version.deactivate! if false == activate
    version.update(options) if options.any?

    version
  end
end

RSpec.configure do |config|
  config.include(ServiceHelper)
  config.before(:each) { ServiceHelper.reset unless Fastly.mocking? }
end
