# frozen_string_literal: true
class Fastly::Service
  include Fastly::Model

  identity :id

  attribute :active_version, type: :integer
  attribute :created_at, type: :time
  attribute :customer_id # Which customer this service belongs to.
  attribute :deleted_at, type: :time
  attribute :name # The name of this cistern.
  attribute :publish_key # What key to use for the publish streams.
  attribute :updated_at, type: :time
  attribute :version, type: :integer

  has_many :versions, -> { cistern.versions(service_id: identity) }

  def destroy
    requires :identity

    new_attributes = cistern.destroy_service(identity).body
    merge_attributes(new_attributes)
  end

  def save
    new_attributes = if new_record?
                       cistern.create_service(name).body
                     else
                       cistern.update_service(identity, attributes).body
                     end
    merge_attributes(new_attributes)
  end
end
