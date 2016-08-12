# frozen_string_literal: true
class Fastly::ResponseObjects
  include Fastly::Collection

  model Fastly::ResponseObject

  attribute :service_id
  attribute :version_number

  def all
    requires :service_id, :version_number

    load(
      cistern.get_response_objects(service_id, version_number).body
    )
  end

  def get!(identity)
    requires :service_id, :version_number

    new(
      cistern.get_response_object(service_id, version_number, identity).body
    )
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end
end
