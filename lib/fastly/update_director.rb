# frozen_string_literal: true
class Fastly::UpdateDirector
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name quorum retries type capacity comment shield capacity).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/director/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    director = find!(:directors, service_id, number.to_i, name)
    director.merge!(accepted_attributes.merge('updated_at' => timestamp))

    mock_response(director)
  end
end
