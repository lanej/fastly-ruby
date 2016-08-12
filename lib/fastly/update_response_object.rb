# frozen_string_literal: true
class Fastly::UpdateResponseObject
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name cache_condition content content_type status response request_condition).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/response_object/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id, :number, :name, :attributes

  def mock
    response_object = find!(:response_objects, service_id, number.to_i, name)
    response_object.merge!(accepted_attributes.merge('updated_at' => timestamp))

    mock_response(response_object)
  end
end
