# frozen_string_literal: true
class Fastly::DictionaryItems
  include Fastly::Collection

  model Fastly::DictionaryItem

  attribute :service_id
  attribute :dictionary_id

  def all
    requires :service_id, :dictionary_id

    load(
      cistern.get_dictionary_items(service_id, dictionary_id).body
    )
  end

  def get!(key)
    requires :service_id, :dictionary_id

    new(
      cistern.get_dictionary_item(service_id, dictionary_id, key).body
    )
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end

  def upsert(**attributes)
    new(attributes).tap(&:save)
  end
end
