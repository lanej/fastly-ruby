# frozen_string_literal: true
class Fastly::GetLoggers
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/logging/#{r.type}" }

  parameter :service_id, :number, :type

  def mock
    find!(:loggers, service_id, number.to_i)
    loggers = cistern.data.dig(:loggers, service_id, number.to_i).values.select do |logger|
      logger['type'] == type.to_s
    end

    mock_response(loggers)
  end
end
