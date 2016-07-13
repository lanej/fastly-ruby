# frozen_string_literal: true
class Fastly::CreateAclEntry
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(negated comment subnet ip).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/acl/#{r.acl_id}/entry" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :acl_id
  parameter :attributes

  def mock
    find!(:acl_entries, service_id, acl_id)

    collection = find!(:acl_entries, service_id, acl_id)

    id = cistern.new_id

    acl_entry = accepted_attributes.merge('id' => id, 'created_at' => timestamp, 'updated_at' => timestamp)

    collection[id] = acl_entry

    mock_response(acl_entry)
  end
end
