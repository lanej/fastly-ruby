# frozen_string_literal: true
class Fastly::UpdateHeader
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( action cache_condition dst ignore_if_set priority regex request_condition
                            response_condition src type substitution name ).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/header/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    header = find!(:headers, service_id, number.to_i, name)

    updated = header.merge(accepted_attributes)
    updated.merge!(accepted_attributes.merge('updated_at' => timestamp))
    new_name = updated['name']

    parent = find!(:headers, service_id, number.to_i)
    parent.delete(name)
    parent[new_name] = updated

    mock_response(updated)
  end
end
