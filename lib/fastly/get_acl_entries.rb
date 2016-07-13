# frozen_string_literal: true
class Fastly::GetAclEntries
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/acl/#{r.acl_id}/entries" }

  parameter :service_id
  parameter :acl_id

  def mock
    mock_response(cistern.data.dig(:acl_entries, service_id, acl_id).values)
  end
end
