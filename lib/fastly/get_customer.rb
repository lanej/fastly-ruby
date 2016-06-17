# frozen_string_literal: true
class Fastly::GetCustomer
  include Fastly::Request

  request_method :get
  request_path { |r| "/customer/#{r.customer_id}" }

  parameter :customer_id

  def mock
    mock_response(find!(:customers, customer_id))
  end
end
