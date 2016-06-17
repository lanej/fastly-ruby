# frozen_string_literal: true
class Fastly::Domains
  include Fastly::Collection

  model Fastly::Domain

  attribute :service_id
  attribute :version_number

  def all
    requires :service_id, :version_number

    load(
      cistern.get_domains(service_id, version_number).body
    )
  end

  def get(_identity)
    requires :service_id, :version_number

    new(
      cistern.get_domains(service_id, version_number).body
    )
  end

  def new(new_attributes = {})
    super(attributes.merge(new_attributes))
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end
end
