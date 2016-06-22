# frozen_string_literal: true
class Fastly::CreateHeader
  include Fastly::Request

  TYPES = %w(request fetch cache response).freeze
  ACTIONS = %w(set append delete regex regex_repeat).freeze
  REQUIRED_PARAMETERS = %w(type dst).freeze
  ACCEPTED_PARAMETERS = %w( action cache_condition dst ignore_if_set priority regex request_condition
                            response_condition src type substitution name ).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/header" }
  request_params(&:updated_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def self.accepted_parameters
    ACCEPTED_PARAMETERS
  end

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = updated_attributes.fetch('name')
    header = updated_attributes.merge('version' => number, 'service_id' => service_id)

    REQUIRED_PARAMETERS.each do |field|
      next if header[field]
      mock_response({
                      'msg' => AN_ERROR_OCCURRED,
                      'detail' => "No value for required field '#{field}'",
                    }, { status: 400 })
    end

    header['priority'] ||= 100

    cistern.data[:headers][service_id][number.to_i][name] = header

    mock_response(header)
  end
end
