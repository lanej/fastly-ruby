# frozen_string_literal: true
class Fastly::DestroyResponseObject
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/response_object/#{r.name}" }

  parameter :service_id, :number, :name

  def mock
    delete!(:response_objects, service_id, number.to_i, name)
  end
end
