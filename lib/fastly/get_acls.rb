# frozen_string_literal: true
class Fastly::GetAcls
  include Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/acl" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(cistern.data.dig(:acls, service_id, number.to_i).values)
  end
end
