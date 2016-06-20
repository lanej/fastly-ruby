# frozen_string_literal: true
class Fastly::Dictionary
  include Fastly::ServiceVersionModel

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

  has_many :items, -> { cistern.dictionary_items(dictionary_id: identity, service_id: service_id) }

  def save
    new_record? ? create : patch
  end

  def reload
    requires :service_id, :version_number, :name

    @_service = nil
    @_version = nil

    merge_attributes(
      cistern.dictionaries(service_id: service_id, version_number: version_number).get(name).attributes
    )
  rescue Fastly::Response::NotFound
    nil
  end

  def create
    requires :name, :service_id, :version_number

    response = cistern.create_dictionary(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def service
    @_service ||= begin
                    requires :service_id

                    cistern.services.get(service_id)
                  end
  end

  private

  def patch
    requires :name, :service_id, :version_number

    old_name = changed.key?(:name) ? changed[:name].first : name
    response = cistern.update_dictionary(service_id, version_number, old_name, dirty_attributes)
    merge_attributes(response.body)
  end
end
