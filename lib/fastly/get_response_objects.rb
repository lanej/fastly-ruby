# frozen_string_literal: true
class Fastly::GetResponseObjects
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/response_object" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:response_objects, service_id, number.to_i).values)
  end
end
