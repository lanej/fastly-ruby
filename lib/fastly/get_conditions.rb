# frozen_string_literal: true
class Fastly::GetConditions
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/condition" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:conditions, service_id, number.to_i).values)
  end
end
