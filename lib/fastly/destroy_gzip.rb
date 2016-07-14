# frozen_string_literal: true
class Fastly::DestroyGzip
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/gzip/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    delete!(:gzips, service_id, number.to_i, name)
  end
end
