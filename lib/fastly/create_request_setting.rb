# frozen_string_literal: true
class Fastly::CreateRequestSetting
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( action bypass_busy_wait default_host force_miss force_ssl geo_headers hash_keys
                            max_stale_age condition_name timer_support xff name ).freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/request_settings" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :attributes

  def mock
    find!(:service_versions, service_id, number.to_i)
    name = accepted_attributes.fetch('name')
    request_setting = accepted_attributes.merge('version' => number, 'service_id' => service_id)
    cistern.data[:request_settings][service_id][number.to_i][name] = request_setting

    mock_response(request_setting)
  end
end
