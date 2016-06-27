# frozen_string_literal: true
class Fastly::UpdateDictionary
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/dictionary/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    dictionary = find!(:dictionaries, service_id, number.to_i, name)

    updated = dictionary.merge(accepted_attributes)

    Fastly::CreateDictionary.validate(self, updated)

    updated.merge!(accepted_attributes.merge('updated_at' => timestamp))
    new_name = updated['name']

    parent = find!(:dictionaries, service_id, number.to_i)
    parent.delete(name)
    parent[new_name] = updated

    mock_response(updated)
  end
end
