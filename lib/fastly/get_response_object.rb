# frozen_string_literal: true
class Fastly::GetResponseObject
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/response_object/#{r.name}" }

  parameter :service_id, :number, :name

  def mock
    mock_response(find!(:response_objects, service_id, number.to_i, name))
  end
end
