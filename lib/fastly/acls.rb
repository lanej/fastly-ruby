# frozen_string_literal: true
class Fastly::Acls
  include Fastly::Collection

  model Fastly::Acl

  attribute :service_id
  attribute :version_number, type: :integer

  def all
    requires :service_id, :version_number

    load(
      cistern.get_acls(service_id, version_number).body
    )
  end

  def get!(identity)
    requires :service_id, :version_number

    new(
      cistern.get_acl(service_id, version_number, identity).body
    )
  end
end
