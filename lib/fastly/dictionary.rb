# frozen_string_literal: true
class Fastly::Dictionary
  include Fastly::Model

  # The alphanumeric string identifying a dictionary.
  identity :id

  # Time-stamp (GMT) when the dictionary was created.
  attribute :created_at, type: :time
  # Time-stamp (GMT) when the dictionary was deleted.
  attribute :deleted_at, type: :time
  # Name for the Dictionary.
  attribute :name
  # The alphanumeric string identifying a service.
  attribute :service_id
  # Time-stamp (GMT) when the dictionary was updated.
  attribute :updated_at, type: :time
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def save
    new_record? ? create : update
  end

  def create
    requires :name, :service_id, :version_number

    response = cistern.create_dictionary(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def update
    raise NotImplementedError
  end
end
