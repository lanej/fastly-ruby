# frozen_string_literal: true
class Fastly::GetDirector
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/director/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    director = find!(:directors, service_id, number.to_i, name)

    mock_response(director)
  end
end
