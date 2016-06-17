# frozen_string_literal: true
class Fastly::GetVersions
  include Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version" }

  parameter :service_id

  def mock
    find!(:services, service_id)

    versions = cistern.data[:service_versions][service_id].values

    mock_response(versions)
  end
end
