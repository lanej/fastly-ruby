# frozen_string_literal: true
class Fastly::CreateAcl
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/acl" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def self.validate(request, dictionary)
    name = dictionary['name']
    unless name
      request.mock_response({ 'msg' => "Name can't be blank" }, { status: 400 })
    end

    unless name =~ /\A[a-zA-Z]/ && name =~ /\A[A-Za-z0-9_]+\Z/
      request.mock_response(
        { 'detail' => 'Name must start with alphabetical and contain only alphanumeric, underscore, and whitespace' },
        { status: 400 }
      )
    end
  end

  def mock
    find!(:service_versions, service_id, number.to_i)

    acl = accepted_attributes.merge(
      'version'    => number,
      'service_id' => service_id,
      'id'         => cistern.new_id,
      'created_at' => timestamp,
      'updated_at' => timestamp,
      'deleted_at' => nil,
    )

    self.class.validate(self, acl)

    name = acl['name']

    cistern.data[:acls][service_id][number.to_i][name] = acl

    mock_response(acl)
  end
end
