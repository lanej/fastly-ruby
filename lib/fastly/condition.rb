# frozen_string_literal: true
class Fastly::Condition
  include Fastly::ServiceVersionModel

  # Name of the condition.
  identity :name

  # A comment.
  attribute :comment
  # Priority assigned to condition. Order executes from 1 to 10, with 1 being first and 10 being last.
  attribute :priority, type: :integer
  # The alphanumeric string identifying a service.
  attribute :service_id
  # The statement used to determine if the condition is met.
  attribute :statement
  # Type of the condition, either "REQUEST" (req), "RESPONSE" (req, resp), or "CACHE" (req, beresp).
  attribute :type
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def save
    requires :service_id, :version_number, :name

    old_name = changed.key?(:name) ? changed[:name].first : name
    response = cistern.update_condition(service_id, version_number, old_name, dirty_attributes)
    merge_attributes(response.body)
  end

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_condition(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def reload
    requires :service_id, :version_number, :identity

    @_service = nil
    @_version = nil

    merge_attributes(
      cistern.conditions(service_id: service_id, version_number: version_number).get(identity).attributes
    )
  rescue Fastly::Response::NotFound
    nil
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_condition(service_id, version_number, identity)
  end
end
