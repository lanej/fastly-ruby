# frozen_string_literal: true
class Fastly::ValidateVersion
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/validate" }

  parameter :service_id
  parameter :number

  def mock
    domains = find!(:domains, service_id, number.to_i)

    if domains.none?
      return mock_response('msg' => 'Version has no associated domains',
                           'status' => 'error',)
    end

    mock_response('status' => 'ok')
  end
end
