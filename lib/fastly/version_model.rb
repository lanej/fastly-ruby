# frozen_string_literal: true
class Fastly::Version
  include Fastly::Model

  identity :id, alias: 'number', type: :integer

  # Whether this is the active version or not.
  attribute :active, type: :boolean
  # A comment.
  attribute :comment
  # Time-stamp (GMT) when the version was created.
  attribute :created_at, type: :time
  # Time-stamp (GMT) when the version was deleted.
  attribute :deleted_at, type: :time
  # Whether or not this version is deployed.
  attribute :deployed, type: :boolean
  # Whether this version is locked or not. Objects can not be added or edited on locked versions.
  attribute :locked, type: :boolean
  # The number of this version.
  attribute :number, type: :integer
  # The alphanumeric string identifying a service.
  attribute :service_id
  # Whether or not this version is for staging.
  attribute :staging, type: :boolean
  # Whether or not this version is for testing.
  attribute :testing, type: :boolean
  # Time-stamp (GMT) when the version was updated.
  attribute :updated_at, type: :time

  belongs_to :service, -> { cistern.services.get(service_id) }

  has_many :domains,      -> { cistern.domains(service_id: service_id, version_number: number) }
  has_many :backends,     -> { cistern.backends(service_id: service_id, version_number: number) }
  has_many :dictionaries, -> { cistern.dictionaries(service_id: service_id, version_number: number) }
  has_many :conditions,   -> { cistern.conditions(service_id: service_id, version_number: number) }
  has_many :directors,    -> { cistern.directors(service_id: service_id, version_number: number) }

  ignore_attributes :service

  def activate!
    requires :service_id, :number

    response = cistern.activate_version(service_id, number)
    merge_attributes(response.body)
  end

  def deactivate!
    requires :service_id, :number

    response = cistern.deactivate_version(service_id, number)
    merge_attributes(response.body)
  end

  def clone!
    requires :service_id, :number

    response = cistern.clone_version(service_id, number)
    cistern.versions(service_id: service_id).new(response.body)
  end

  def lock!
    requires :service_id, :number

    response = cistern.lock_version(service_id, number)
    merge_attributes(response.body)
  end

  def validate
    requires :service_id, :number

    data = cistern.validate_version(service_id, number).body
    return [true, nil] if data['status'] == 'ok'
    [false, data['msg']]
  end

  def reload
    requires :service_id, :identity

    latest = cistern.versions(service_id: service_id).get(identity)
    merge_attributes(latest.attributes) if latest
  end

  def save
    new_attributes = if new_record?
                       cistern.create_version(service_id, attributes).body
                     else
                       cistern.update_version(service_id, number, dirty_attributes).body
                     end
    merge_attributes(new_attributes)
  end
end
