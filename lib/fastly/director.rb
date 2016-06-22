# frozen_string_literal: true
class Fastly::Director
  include Fastly::ServiceVersionModel

  # Name for the Director.
  identity :name

  # List of backend associated with this director.
  attribute :backends, type: :array
  # Load balancing weight for the backends.
  attribute :capacity, type: :integer
  # Description field.
  attribute :comment
  # Time-stamp (GMT) when the Director was created.
  attribute :created_at, type: :time
  # Time-stamp (GMT) when the Director was deleted.
  attribute :deleted_at, type: :time
  # The percentage of capacity that needs to be up for a director to be considered up. Integer, 0 to 100 (default: 75)
  attribute :quorum, type: :integer
  # The alphanumeric string identifying a service.
  attribute :service_id
  # Selected POP to serve as a "shield" for origin servers.
  attribute :shield
  # What type of load balance group to use.
  #   Integer, 1 to 4. Values: 1=random, 2=round-robin, 3=hash, 4=client. (default: 1)
  attribute :type, type: :integer
  # Time-stamp (GMT) when the Director was updated.
  attribute :updated_at, type: :time
  # How many backends to search if it fails. (default: 5)
  attribute :retries, type: :integer
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_director(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_director(service_id, version_number, identity)
  end

  def save
    requires :service_id, :version_number, :identity

    response = cistern.update_director(service_id, version_number, name, dirty_attributes)
    merge_attributes(response.body)
  end
end
