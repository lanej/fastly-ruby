# frozen_string_literal: true
class Fastly::AclEntries
  include Fastly::Collection

  model Fastly::AclEntry

  attribute :service_id
  attribute :acl_id

  def all
    requires :service_id, :acl_id

    load(
      cistern.get_acl_entries(service_id, acl_id).body
    )
  end

  def get!(key)
    requires :service_id, :acl_id

    new(
      cistern.get_acl_entry(service_id, acl_id, key).body
    )
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end

  def upsert(**attributes)
    new(attributes).tap(&:save)
  end
end
