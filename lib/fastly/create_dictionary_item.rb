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
    existing_item = cistern.data.dig(:dictionary_items, service_id, dictionary_id, key)

    if existing_item
      mock_response({
                      'msg' => 'Duplicate record',
                      'detail' => 'Duplicate dictionary_item: ',
                    }, { status: 409 })
    end

    cistern.upsert_dictionary_item(service_id, dictionary_id, key, value)
  end
end
