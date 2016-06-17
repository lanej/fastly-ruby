class Fastly::DestroyBackend
  include Fastly::Request
  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/backend/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    delete!(:backends, service_id, number.to_i, name)
  end
end
