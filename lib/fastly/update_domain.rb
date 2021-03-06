# frozen_string_literal: true
class Fastly::UpdateDomain
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name comment).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/domain/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    domain = find!(:domains, service_id, number.to_i, name)
    domain.merge!(accepted_attributes.merge('updated_at' => timestamp))

    mock_response(domain)
  end
end
