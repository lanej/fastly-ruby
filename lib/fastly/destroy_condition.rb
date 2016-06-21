# frozen_string_literal: true
class Fastly::DestroyCondition
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/condition/#{r.name}" }

  parameter :service_id
  parameter :number
  parameter :name

  def mock
    delete!(:conditions, service_id, number.to_i, name)
  end
end
