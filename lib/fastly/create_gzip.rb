# frozen_string_literal: true
class Fastly::CreateGzip
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w(name cache_condition extensions content_types).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/gzip" }
  request_params(&:accepted_attributes)

  parameter :service_id, :number, :attributes

  def mock
    name = accepted_attributes['name']
    existing_item = cistern.data.dig(:gzips, service_id, number.to_i, name)

    if existing_item
      mock_response({
                      'msg' => 'Duplicate record',
                      'detail' => 'Duplicate gzip: ',
                    }, { status: 409 })
    end

    find!(:service_versions, service_id, number.to_i)
    gzip = accepted_attributes.merge('version' => number, 'service_id' => service_id)
    cistern.data[:gzips][service_id][number.to_i][name] = gzip

    mock_response(gzip)
  end
end
