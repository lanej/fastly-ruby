# frozen_string_literal: true
class Fastly::AclEntry
  include Fastly::Model

  identity :id

  attribute :service_id
  # An IP address.
  attribute :ip
  # An optional subnet for the IP address.
  attribute :subnet, type: :integer
  # The Acl this entry belongs to.
  attribute :acl_id
  # A boolean that will negate the match if true.
  attribute :negated, type: :boolean
  # A personal freeform descriptive note.
  attribute :comment

  ignore_attributes :service

  belongs_to :service, -> { cistern.services.get(service_id) }

  def save
    id.nil? ? create : patch
  end

  def create
    requires :ip, :service_id, :acl_id

    response = cistern.create_acl_entry(service_id, acl_id, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :acl_id, :identity

    cistern.destroy_acl_entry(service_id, acl_id, identity)
  end

  def patch
    requires :service_id, :acl_id, :identity

    response = cistern.update_acl_entry(service_id, acl_id, identity, dirty_attributes)
    merge_attributes(response.body)
  end
end
