# frozen_string_literal: true
class Fastly::DestroyLogger
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/logging/#{r.type}/#{r.name}" }

  parameter :service_id, :number, :type, :name

  def mock
    delete!(:loggers, service_id, number.to_i, name)
  end
end
