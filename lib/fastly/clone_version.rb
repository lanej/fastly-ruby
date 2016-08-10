# frozen_string_literal: true
class Fastly::CloneVersion
  include Fastly::Request

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/clone" }

  parameter :service_id
  parameter :number

  def mock
    service_versions = find!(:service_versions, service_id)
    version = find!(:service_versions, service_id, number.to_i).dup
    latest = service_versions.keys.max + 1

    service_versions[latest] = version.merge!('number' => latest)

    mock_response(version)
  end
end
