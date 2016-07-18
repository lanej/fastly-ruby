require 'spec_helper'

describe Fastly, 'session authentication', :real do
  it 'logs in automagically' do
    client = create_client(via: :credentials)
    client.customers.current
  end
end
