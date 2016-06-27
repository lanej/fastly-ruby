# frozen_string_literal: true
class Fastly::UpdateCondition
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(priority statement comment type).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/condition/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    condition = find!(:conditions, service_id, number.to_i, name)
    condition.merge!(accepted_attributes.merge('updated_at' => Time.now.iso8601))

    mock_response(condition)
  end
end
