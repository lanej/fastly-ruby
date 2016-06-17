# frozen_string_literal: true
class Fastly::GetCurrentCustomer
  include Fastly::Request
  request_method :get
  request_path { |_| '/current_customer' }

  def mock
    mock_response(find!(:customers, cistern.current_customer_id))
  end
end
