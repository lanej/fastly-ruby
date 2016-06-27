# frozen_string_literal: true
class Fastly::UpdateService
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name comment).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :attributes

  def mock
    resource = find!(:services, service_id)
    resource.merge!(accepted_attributes)

    mock_response(resource)
  end
end
