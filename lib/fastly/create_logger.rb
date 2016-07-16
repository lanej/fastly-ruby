# frozen_string_literal: true
class Fastly::CreateLogger
  include Fastly::Request

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/logging/#{r.type}" }
  request_params(&:attributes)

  parameter :service_id, :number, :type, :name, :attributes

  def accepted_attributes
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(attributes))
  end

  def mock
    find!(:service_versions, service_id, number.to_i)
    logger = accepted_attributes.merge(
      'version' => number,
      'service_id' => service_id,
      'type' => type.to_s,
      'name' => name,
    )
    cistern.data[:loggers][service_id][number.to_i][name] = logger

    mock_response(logger)
  end

  def reload
    requires :service_id, :version_number, :type, :identity

    latest = collection.get(identity)
    merge_attributes(latest.attributes) if latest
  end
end
