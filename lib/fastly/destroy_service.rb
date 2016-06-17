# frozen_string_literal: true
class Fastly::DestroyService
  include Fastly::Request
  request_method :delete
  request_path { |r| "/service/#{r.service_id}" }

  parameter :service_id

  def mock
    service = find!(:services, service_id)
    service['deleted_at'] = Time.now.iso8601

    response(body: { 'status' => 'ok' })
  end
end
