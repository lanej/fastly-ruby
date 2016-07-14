# frozen_string_literal: true
class Fastly::GetGzip
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/gzip/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    gzip = find!(:gzips, service_id, number.to_i, name)

    mock_response(gzip)
  end
end
