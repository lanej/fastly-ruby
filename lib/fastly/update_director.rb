# frozen_string_literal: true
class Fastly::UpdateDirector
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name quorum retries type capacity comment shield capacity).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/director/#{r.name}" }
  request_params(&:updated_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def self.accepted_parameters
    ACCEPTED_PARAMETERS
  end

  def mock
    director = find!(:directors, service_id, number.to_i, name)
    director.merge!(updated_attributes.merge('updated_at' => Time.now.iso8601))

    mock_response(director)
  end
end
