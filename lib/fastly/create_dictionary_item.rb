# frozen_string_literal: true
class Fastly::CreateDictionaryItem
  include Fastly::Request

  request_method :post
  request_path { |r| "/service/#{r.service_id}/dictionary/#{r.dictionary_id}/item" }
  request_params { |r| { 'item_key' => r.key, 'item_value' => r.value } }

  parameter :service_id
  parameter :dictionary_id
  parameter :key
  parameter :value

  def mock
    find!(:dictionaries, service_id) do |sv|
      sv.values.find { |d| d.values.find { |dict| dict['id'] == dictionary_id } }
    end

    dictionary_item = {
      'item_key' => key,
      'item_value' => value,
      'created_at' => timestamp,
      'updated_at' => timestamp,
      'deleted_at' => nil,
    }

    cistern.data[:dictionary_items][service_id][dictionary_id][key] = dictionary_item

    mock_response(dictionary_item)
  end
end
