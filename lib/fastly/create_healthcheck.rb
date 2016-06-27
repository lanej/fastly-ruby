# frozen_string_literal: true
class Fastly::CreateHealthcheck
  include Fastly::Request

  REQUIRED_PARAMETERS = %w(host path name).freeze
  ACCEPTED_PARAMETERS = %w( check_interval comment expected_response host http_version initial http_method method meta
                            name path service_id threshold timeout version window ).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/healthcheck" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def accepted_attributes
    super.tap { |attrs| attrs['method'] ||= attrs.delete('http_method') }
  end

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
