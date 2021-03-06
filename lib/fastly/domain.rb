# frozen_string_literal: true
class Fastly::Domain
  include Fastly::ServiceVersionModel

  identity :id, alias: 'name'

  # A personal freeform descriptive note.
  attribute :comment
  # The name of the domain or domains associated with this service.
  attribute :name
  # The alphanumeric string identifying a service.
  attribute :service_id
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_domain(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_domain(service_id, version_number, identity)
  end

  def save
    requires :service_id, :version_number, :identity

    response = cistern.update_domain(service_id, version_number, name, dirty_attributes)
    merge_attributes(response.body)
  end
end
