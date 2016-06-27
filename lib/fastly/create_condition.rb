# frozen_string_literal: true
class Fastly::CreateCondition
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name priority statement type comment).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/condition" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = accepted_attributes.fetch('name')
    condition = accepted_attributes.merge('version' => number, 'service_id' => service_id)
    cistern.data[:conditions][service_id][number.to_i][name] = condition

    mock_response(condition)
  end
end
