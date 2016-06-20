# frozen_string_literal: true
class Fastly::Version
  include Fastly::Model

  identity :id, alias: 'number', type: :integer

  # Whether this is the active version or not.
  attribute :active,           type: :boolean
  attribute :cache_settings,   type: :array
  attribute :comment
  attribute :conditions,       type: :array
  attribute :created_at,       type: :time
  attribute :deleted_at,       type: :time
  attribute :deployed,         type: :boolean
  attribute :directors,        type: :array
  attribute :gzips,            type: :array
  attribute :headers,          type: :array
  attribute :healthchecks,     type: :array
  # Whether this version is locked or not. Objects can not be added or edited on locked versions.
  attribute :locked,           type: :boolean
  attribute :matches,          type: :array
  # The number of this version.
  attribute :number,           type: :integer
  attribute :origins,          type: :array
  attribute :request_settings, type: :array
  attribute :response_objects, type: :array
  attribute :service_id
  attribute :settings
  attribute :staging,          type: :boolean
  attribute :testing,          type: :boolean
  attribute :updated_at,       type: :time
  attribute :vcls,             type: :array
  attribute :wordpress,        type: :array

  belongs_to :service, -> { cistern.services.get(service_id) }

  has_many :domains,      -> { cistern.domains(service_id: service_id, version_number: number) }
  has_many :backends,     -> { cistern.backends(service_id: service_id, version_number: number) }
  has_many :dictionaries, -> { cistern.dictionaries(service_id: service_id, version_number: number) }

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

    merge_attributes(
      cistern.versions(service_id: service_id).get(identity).attributes
    )
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
