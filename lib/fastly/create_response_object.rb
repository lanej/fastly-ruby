# frozen_string_literal: true
class Fastly::CreateResponseObject
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name cache_condition content content_type status response request_condition).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/response_object" }
  request_params(&:accepted_attributes)

  parameter :service_id, :number, :attributes

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = accepted_attributes.fetch('name')
    response_object = accepted_attributes.merge('version' => number, 'service_id' => service_id)

    cache_condition_name = response_object['cache_condition']

    if cache_condition_name
      find!(:conditions, service_id) { |vc| vc.values.find { |c| c[cache_condition_name] } }
    end

    request_condition_name = response_object['request_condition']

    if request_condition_name
      request_condition = find!(:conditions, service_id) { |vc| vc.values.find { |c| c[request_condition_name] } }

      mock_response({
                      'msg' => AN_ERROR_OCCURRED,
                      'detail' => "Condition '#{request_condition_name}' is not a request condition",
                    }, { status: 400 }) unless request_condition['type'] == 'REQUEST'
    end

    cistern.data[:response_objects][service_id][number.to_i][name] = response_object

    mock_response(response_object)
  end
end
