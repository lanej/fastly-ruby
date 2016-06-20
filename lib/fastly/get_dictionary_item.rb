# frozen_string_literal: true
class Fastly::GetDictionaryItem
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/dictionary/#{r.dictionary_id}/item/#{r.key}" }

  parameter :service_id
  parameter :dictionary_id
  parameter :key

  def mock
    mock_response(find!(:dictionary_items, service_id, dictionary_id, key))
  end
end
