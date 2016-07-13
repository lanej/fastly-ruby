# frozen_string_literal: true
class Fastly::UpdateAclEntry
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(negated comment subnet ip).freeze

  request_method :patch
  request_path { |r| "/service/#{r.service_id}/acl/#{r.acl_id}/entry/#{r.entry_id}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :acl_id
  parameter :entry_id
  parameter :attributes

  def mock
    acl_entry = find!(:acl_entries, service_id, acl_id, entry_id)

    updated = acl_entry.merge!(accepted_attributes).merge('updated_at' => timestamp)

    mock_response(updated)
  end
end
