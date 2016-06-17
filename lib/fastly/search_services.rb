# frozen_string_literal: true
class Fastly::SearchServices
  include Fastly::Request

  def self.search_params
    %w(name)
  end

  request_method :get
  request_path { |_r| '/service/search' }
  request_params(&:search_params)

  parameter :params

  def search_params
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(params), *self.class.search_params)
  end

  def mock
    matched_service = cistern.data[:services].values.find do |s|
      Cistern::Hash.slice(s, *search_params.keys) == search_params
    end

    matched_service['customer_id'] = cistern.current_customer.identity
    matched_service['versions'] = cistern.data[:service_versions][matched_service['id'].to_i].values

    mock_response(matched_service)
  end
end
