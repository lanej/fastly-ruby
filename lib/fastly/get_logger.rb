# frozen_string_literal: true
class Fastly::GetLogger
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/logging/#{r.type}/#{r.name}" }

  parameter :service_id, :number, :type, :name

  def mock
    logger = find!(:loggers, service_id, number.to_i, name)

    mock_response(logger)
  end
end
