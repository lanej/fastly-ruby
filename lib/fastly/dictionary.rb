# frozen_string_literal: true
class Fastly::Dictionary
  include Fastly::ServiceVersionModel

  # Name for the Dictionary.
  identity :name

  # Time-stamp (GMT) when the dictionary was created.
  attribute :created_at, type: :time
  # Time-stamp (GMT) when the dictionary was deleted.
  attribute :deleted_at, type: :time
  # The alphanumeric string identifying a dictionary.
  attribute :id
  # The alphanumeric string identifying a service.
  attribute :service_id
  # Time-stamp (GMT) when the dictionary was updated.
  attribute :updated_at, type: :time
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  has_many :items, -> { cistern.dictionary_items(dictionary_id: id, service_id: service_id) }

  def destroy
    requires :service_id, :version_number, :name

    cistern.destroy_dictionary(service_id, version_number, name)
  end

  def save
    requires :name, :service_id, :version_number

    old_name = changed.key?(:name) ? changed[:name].first : name
    response = cistern.update_dictionary(service_id, version_number, old_name, dirty_attributes)
    merge_attributes(response.body)
  end

  def create
    requires :name, :service_id, :version_number

    response = cistern.create_dictionary(service_id, version_number, attributes)
    merge_attributes(response.body)
  end
end
