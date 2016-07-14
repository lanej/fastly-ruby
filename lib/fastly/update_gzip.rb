# frozen_string_literal: true
class Fastly::UpdateGzip
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name cache_condition extensions content_types).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/gzip/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    gzip = find!(:gzips, service_id, number.to_i, name)

    updated = gzip.merge(accepted_attributes).merge('updated_at' => timestamp)

    new_name = updated['name']

    parent = find!(:gzips, service_id, number.to_i)
    parent.delete(name)
    parent[new_name] = updated

    mock_response(updated)
  end
end
