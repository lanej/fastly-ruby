# frozen_string_literal: true
module Fastly::HealthcheckRequest
  REQUIRED_PARAMETERS = %w(host path name).freeze
  ACCEPTED_PARAMETERS = %w( check_interval comment expected_response host http_version initial http_method method meta
                            name path service_id threshold timeout version window ).freeze

  def accepted_attributes
    super.tap do |attrs|
      http_method = attrs.delete('http_method')
      attrs['method'] ||= http_method
    end
  end
end
