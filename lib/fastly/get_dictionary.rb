# frozen_string_literal: true
class Fastly::GetDictionary
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/dictionary/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    dictionary = find!(:dictionaries, service_id, number.to_i, name)

    mock_response(dictionary)
  end
end
