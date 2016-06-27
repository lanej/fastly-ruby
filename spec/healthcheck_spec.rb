# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a healthcheck' do
    name = SecureRandom.hex(3)

    healthcheck = client.healthchecks.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
      host: 'example.com',
      path: '/test.txt',
    )

    expect(healthcheck.name).to eq(name)
    expect(healthcheck.reload.name).to eq(name)
  end
end
