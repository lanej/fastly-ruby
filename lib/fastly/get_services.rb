# frozen_string_literal: true
class Fastly::GetServices
  include Fastly::Request
  request_method :get
  request_path { |_r| '/service' }

  def mock
    services = cistern.data[:services].values.select do |s|
      s['customer_id'] == cistern.current_customer.identity && s['deleted_at'].nil?
    end
    services.each { |s| s['versions'] = cistern.data[:service_versions][s['id'].to_i].values }

    mock_response(services)
  end
end
