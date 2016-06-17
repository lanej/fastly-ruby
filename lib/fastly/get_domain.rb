# frozen_string_literal: true
class Fastly::GetDomain
  include Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/domain/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    domain = find!(:domains, service_id, number.to_i, name)

    mock_response(domain)
  end
end
