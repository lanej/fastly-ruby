# frozen_string_literal: true
class Fastly::CreateDomain
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name comment).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/domain" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = accepted_attributes.fetch('name')
    domain = accepted_attributes.merge('version' => number, 'service_id' => service_id)
    cistern.data[:domains][service_id][number.to_i][name] = domain

    mock_response(domain)
  end
end
