# frozen_string_literal: true
class Fastly::Dictionaries
  include Fastly::Collection

  model Fastly::Dictionary

  attribute :service_id
  attribute :version_number

  def all
    requires :service_id, :version_number

    load(
      cistern.get_dictionaries(service_id, version_number).body
    )
  end

  def get(identity)
    requires :service_id, :version_number

    new(
      cistern.get_dictionary(service_id, version_number, identity).body
    )
  end
end
