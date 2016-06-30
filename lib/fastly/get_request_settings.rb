# frozen_string_literal: true
class Fastly::GetRequestSettings
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/request_settings" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:request_settings, service_id, number.to_i).values)
  end
end
