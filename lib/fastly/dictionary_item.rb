# frozen_string_literal: true
class Fastly::DictionaryItem
  include Fastly::Model

  # Time-stamp (GMT) when the dictionary was created.
  attribute :created_at, type: :time
  # Time-stamp (GMT) when the dictionary was deleted.
  attribute :deleted_at, type: :time
  # The dictionary for this Item.
  attribute :dictionary_id
  # Key for the DictionaryItem.
  attribute :key, alias: 'item_key'
  # Value for the DictionaryItem.
  attribute :value, alias: 'item_value'
  # The service the Dictionary belongs to.
  attribute :service_id
  # Time-stamp (GMT) when the dictionary was updated.
  attribute :updated_at, type: :time

  belongs_to :service, -> { cistern.services.get(service_id) }

  def destroy
    requires :service_id, :dictionary_id, :key

    response = cistern.destroy_dictionary_item(service_id, dictionary_id, key)
    merge_attributes(response.body)
  end

  # upsert
  def save
    requires :service_id, :dictionary_id, :key

    response = cistern.upsert_dictionary_item(service_id, dictionary_id, key, value)
    merge_attributes(response.body)
  end

  def reload
    requires :service_id, :dictionary_id, :key

    @_service = nil

    merge_attributes(
      cistern.dictionary_items(service_id: service_id, dictionary_id: dictionary_id).get(key).attributes
    )
  rescue Fastly::Response::NotFound
    nil
  end

  def create
    requires :service_id, :dictionary_id, :key, :value

    response = cistern.create_dictionary_item(service_id, dictionary_id, key, value)
    merge_attributes(response.body)
  end
end
