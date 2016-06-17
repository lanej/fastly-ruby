# frozen_string_literal: true
class Fastly::CreateVersion
  include Fastly::Request
  request_method :post
  request_path { |r| "/service/#{r.service_id}/version" }
  request_params(&:updated_attributes)

  def self.accepted_parameters
    %w(comment testing staging deployed)
  end

  parameter :service_id
  parameter :attributes

  def updated_attributes
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(attributes), *self.class.accepted_parameters)
  end

  def mock
    find!(:services, service_id)
    latest_version = cistern.data[:service_versions][service_id].values.last.dup
    number = latest_version['number'] = (latest_version['number'].to_i + 1).to_s
    cistern.data[:service_versions][service_id][number] = latest_version.merge!(updated_attributes)

    mock_response(latest_version)
  end
end
