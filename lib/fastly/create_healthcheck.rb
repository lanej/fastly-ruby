# frozen_string_literal: true
class Fastly::CreateHealthcheck
  include Fastly::Request
  include Fastly::HealthcheckRequest

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/healthcheck" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = accepted_attributes.fetch('name')
    healthcheck = accepted_attributes.merge('version' => number, 'service_id' => service_id)

    REQUIRED_PARAMETERS.each do |field|
      next if healthcheck[field]
      mock_response({
                      'msg' => AN_ERROR_OCCURRED,
                      'detail' => "No value for required field '#{field}'",
                    }, { status: 400 })
    end

    healthcheck['method'] ||= 'HEAD'
    cistern.data[:healthchecks][service_id][number.to_i][name] = healthcheck

    mock_response(healthcheck)
  end
end
