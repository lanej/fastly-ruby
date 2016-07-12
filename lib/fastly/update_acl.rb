# frozen_string_literal: true
class Fastly::UpdateAcl
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/acl/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    acl = find!(:acls, service_id, number.to_i, name)

    updated = acl.merge(accepted_attributes).merge('updated_at' => timestamp)

    Fastly::CreateDictionary.validate(self, updated)

    new_name = updated['name']

    parent = find!(:acls, service_id, number.to_i)
    parent.delete(name)
    parent[new_name] = updated

    mock_response(updated)
  end
end
