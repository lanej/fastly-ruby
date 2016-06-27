# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a header' do
    name = SecureRandom.hex(3)

    header = client.headers.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
      type: :request,
      action: :set,
      dst: 'http.x-fastly-client-src',
      src: 'server.identity',
    )

    expect(header.name).to eq(name)
    expect(header.reload.name).to eq(name)
  end
end
