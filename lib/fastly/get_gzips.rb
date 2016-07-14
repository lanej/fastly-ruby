# frozen_string_literal: true
class Fastly::GetGzips
  include Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/gzip" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:gzips, service_id, number.to_i).values)
  end
end
