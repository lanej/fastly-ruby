# frozen_string_literal: true
class Fastly::Versions
  include Fastly::Collection

  model Fastly::Version

  attribute :service_id

  def all
    requires :service_id

    load(
      cistern.get_versions(service_id).body
    )
  end

  def get(identity)
    requires :service_id

    new(
      cistern.get_version(service_id, identity).body
    )
  end
end
