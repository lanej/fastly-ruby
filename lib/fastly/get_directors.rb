# frozen_string_literal: true
class Fastly::GetDirectors
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/director" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:directors, service_id, number.to_i).values)
  end
end
