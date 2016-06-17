# frozen_string_literal: true
class Fastly::GetBackend
  include Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/backend/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    backend = find!(:backends, service_id, number.to_i, name)

    mock_response(backend)
  end
end
