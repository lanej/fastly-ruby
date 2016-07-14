# frozen_string_literal: true
class Fastly::Gzips
  include Fastly::Collection

  model Fastly::Gzip

  attribute :service_id
  attribute :version_number, type: :integer

  def all
    requires :service_id, :version_number

    load(
      cistern.get_gzips(service_id, version_number).body
    )
  end

  def get!(identity)
    requires :service_id, :version_number

    new(
      cistern.get_gzip(service_id, version_number, identity).body
    )
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end
end
