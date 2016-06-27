# frozen_string_literal: true
class Fastly::UpdateVersion
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(comment testing staging deployed).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    find!(:services, service_id)
    version = cistern.data[:service_versions][service_id].fetch(number.to_i)
    version.merge!(accepted_attributes.merge('updated_at' => Time.now.iso8601))

    mock_response(version)
  end
end
