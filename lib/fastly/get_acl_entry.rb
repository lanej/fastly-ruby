# frozen_string_literal: true
class Fastly::GetAclEntry
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/acl/#{r.acl_id}/entry/#{r.entry_id}" }

  parameter :service_id
  parameter :acl_id
  parameter :entry_id

  def mock
    acl_entry = find!(:acl_entries, service_id, acl_id, entry_id)

    mock_response(acl_entry)
  end
end
