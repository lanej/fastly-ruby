# frozen_string_literal: true
class Fastly::CreateDirector
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( name quorum retries type capacity comment shield capacity ).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/director" }
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
    director = updated_attributes.merge(
      'version' => number,
      'service_id' => service_id,
      'updated_at' => timestamp,
      'created_at' => timestamp,
    )

    # defaults
    director['backends'] ||= []
    director['quorum'] ||= 75
    director['retries'] ||= 5
    director['type'] ||= 1
    director['capacity'] ||= 100

    cistern.data[:directors][service_id][number.to_i][name] = director

    mock_response(director)
  end
end
