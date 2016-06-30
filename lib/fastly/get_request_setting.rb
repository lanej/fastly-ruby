# frozen_string_literal: true
class Fastly::GetRequestSetting
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/request_settings/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    mock_response(find!(:request_settings, service_id, number.to_i, name))
  end
end
