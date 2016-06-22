# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:client) { create_client }

  it 'fetches the current customer' do
    if Fastly.mocking?
      expect(client.customers.current).to eq(client.current_customer)
    else
      expect(client.customers.current.identity).not_to be_nil
    end
  end
end
