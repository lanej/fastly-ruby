# frozen_string_literal: true
class Fastly::GetDictionaryItems
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/dictionary/#{r.dictionary_id}/items" }

  parameter :service_id
  parameter :dictionary_id

  def mock
    mock_response(cistern.data.dig(:dictionary_items, service_id, dictionary_id).values)
  end
end
