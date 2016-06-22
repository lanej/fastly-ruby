# frozen_string_literal: true
class Fastly::DestroyDirector
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/director/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    delete!(:directors, service_id, number.to_i, name)
  end
end
