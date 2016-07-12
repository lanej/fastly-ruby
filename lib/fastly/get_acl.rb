# frozen_string_literal: true
class Fastly::GetAcl
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/acl/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    acl = find!(:acls, service_id, number.to_i, name)

    mock_response(acl)
  end
end
