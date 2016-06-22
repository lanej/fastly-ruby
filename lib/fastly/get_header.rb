# frozen_string_literal: true
class Fastly::GetHeader
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/header/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    header = find!(:headers, service_id, number.to_i, name)

    mock_response(header)
  end
end
