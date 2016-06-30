# frozen_string_literal: true
class Fastly::CreateRequestSetting
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name priority statement type comment).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/request_settings" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = accepted_attributes.fetch('name')
    request_setting = accepted_attributes.merge('version' => number, 'service_id' => service_id)
    cistern.data[:request_settings][service_id][number.to_i][name] = request_setting

    mock_response(request_setting)
  end
end
