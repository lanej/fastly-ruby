# frozen_string_literal: true
class Fastly::GetHeaders
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/header" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:headers, service_id, number.to_i).values)
  end
end
