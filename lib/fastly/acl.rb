# frozen_string_literal: true
class Fastly::Acl
  include Fastly::ServiceVersionModel

  identity :name

  attribute :id
  attribute :service_id
  attribute :version_number, alias: 'version', type: :integer
  attribute :created_at, type: :time
  attribute :updated_at, type: :time
  attribute :deleted_at, type: :time

  has_many :entries, -> { cistern.acl_entries(acl_id: id, service_id: service_id) }

  def save
    id.nil? ? create : patch
  end

  def create
    requires :name, :service_id, :version_number

    response = cistern.create_acl(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_acl(service_id, version_number, identity)
  end

  def patch
    requires :name, :service_id, :version_number

    old_name = changed.key?(:name) ? changed[:name].first : name
    response = cistern.update_acl(service_id, version_number, old_name, dirty_attributes)
    merge_attributes(response.body)
  end
end
