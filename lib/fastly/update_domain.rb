# frozen_string_literal: true
class Fastly::UpdateDomain
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( name comment ).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/domain/#{name}" }
  request_params(&:updated_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def self.accepted_parameters
    ACCEPTED_PARAMETERS
  end

  def mock
    domain = find!(:domains, service_id, number.to_i, name)
    domain.merge!(updated_attributes.merge('updated_at' => Time.now.iso8601))

    mock_response(domain)
  end
end
