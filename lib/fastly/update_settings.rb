# frozen_string_literal: true
class Fastly::UpdateSettings
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(general.default_ttl general.default_host).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/settings" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    settings = find!(:settings, service_id, number.to_i)

    settings.merge!(accepted_attributes)

    mock_response(settings)
  end
end
