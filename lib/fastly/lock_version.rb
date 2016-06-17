# frozen_string_literal: true
class Fastly::LockVersion
  include Fastly::Request

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/lock" }

  parameter :service_id
  parameter :number

  def mock
    find!(:services, service_id)
    version = cistern.data[:service_versions][service_id].fetch(number.to_i)
    version['locked'] = true

    mock_response(version)
  end
end
