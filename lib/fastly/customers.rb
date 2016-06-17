# frozen_string_literal: true
class Fastly::Customers
  include Fastly::Collection

  model Fastly::Customer

  def all(*_args)
    raise NotImplementedError
  end

  def current
    new(
      cistern.get_current_customer.body
    )
  end
end
