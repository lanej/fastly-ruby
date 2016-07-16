# frozen_string_literal: true
class Fastly::Loggers
  include Fastly::Collection

  model Fastly::Logger

  attribute :service_id
  attribute :version_number
  attribute :type

  def self.add_type(logger_type)
    define_method(logger_type) do
      merge_attributes(type: logger_type)
      self
    end
  end

  def all
    requires :service_id, :version_number, :type

    load(
      cistern.get_loggers(service_id, version_number, type).body
    )
  end

  def get!(identity)
    requires :service_id, :version_number, :type

    new(
      cistern.get_logger(service_id, version_number, type, identity).body
    )
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end

  def model
    requires :type

    super.for(type)
  end
end
