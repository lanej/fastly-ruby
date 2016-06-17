# frozen_string_literal: true
class Fastly::ActivateVersion
  include Fastly::Request
  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/activate" }

  parameter :service_id
  parameter :number

  def mock
    find!(:services, service_id)

    service_versions = cistern.data[:service_versions][service_id]
    version = service_versions.fetch(number.to_i)
    service_versions.values.select { |v| v['active'] &= false }
    version['active'] = true

    mock_response(version)
  end
end
