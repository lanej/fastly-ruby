# frozen_string_literal: true
class Fastly::DestroyAclEntry
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/acl/#{r.acl_id}/entry/#{r.entry_id}" }

  parameter :service_id
  parameter :acl_id
  parameter :entry_id

  def mock
    delete!(:acl_entries, service_id, acl_id, entry_id)
  end
end
