# frozen_string_literal: true
class Fastly::UpdateHealthcheck
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( check_interval comment expected_response host http_version initial http_method method meta
                            name path service_id threshold timeout version window ).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/healthcheck/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    healthcheck = find!(:healthchecks, service_id, number.to_i, name)
    healthcheck.merge!(accepted_attributes.merge('updated_at' => timestamp))

    mock_response(healthcheck)
  end
end
