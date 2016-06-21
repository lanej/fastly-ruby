# frozen_string_literal: true
class Fastly::Conditions
  include Fastly::Collection

  model Fastly::Condition

  attribute :service_id
  attribute :version_number

  def all
    requires :service_id, :version_number

    load(
      cistern.get_conditions(service_id, version_number).body
    )
  end

  def get(identity)
    requires :service_id, :version_number

    new(
      cistern.get_condition(service_id, version_number, identity).body
    )
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end
end
