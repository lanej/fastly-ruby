# frozen_string_literal: true
class Fastly::CreateDictionary
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( name ).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/dictionary" }
  request_params(&:updated_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def self.accepted_parameters
    ACCEPTED_PARAMETERS
  end

  def self.validate(request, dictionary)
    unless dictionary['name']
      request.mock_response({ 'msg' => "Name can't be blank" }, { status: 400 })
    end

    unless dictionary['name'] =~ /\A[a-zA-Z]/
      request.mock_response(
        { 'detail' => 'Name must start with alphabetical and contain only alphanumeric, underscore, and whitespace' },
        { status: 400 }
      )
    end
  end

  def mock
    find!(:service_versions, service_id, number.to_i)

    dictionary = updated_attributes.merge(
      'version' => number,
      'service_id' => service_id,
      'id' => cistern.new_id,
    )

    self.class.validate(self, dictionary)

    name = dictionary['name']

    cistern.data[:dictionaries][service_id][number.to_i][name] = dictionary

    mock_response(dictionary)
  end
end
