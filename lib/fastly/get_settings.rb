# frozen_string_literal: true
class Fastly::GetSettings
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/settings" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(find!(:settings, service_id, number.to_i))
  end
end
