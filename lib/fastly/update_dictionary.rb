# frozen_string_literal: true
class Fastly::UpdateDictionary
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( name ).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/dictionary/#{r.name}" }
  request_params(&:updated_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def self.accepted_parameters
    ACCEPTED_PARAMETERS
  end

  def mock
    dictionary = find!(:dictionaries, service_id, number.to_i, name)

    updated = dictionary.merge(updated_attributes)

    Fastly::CreateDictionary.validate(self, updated)

    updated.merge!(updated_attributes.merge('updated_at' => Time.now.iso8601))

    parent = find!(:dictionaries, service_id, number.to_i)
    parent.delete(name)
    parent[updated['name']] = updated

    mock_response(updated)
  end
end