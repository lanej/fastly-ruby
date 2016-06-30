# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a request_setting' do
    name = SecureRandom.hex(3)

    request_setting = client.request_settings.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
    )

    expect(request_setting.name).to eq(name)
    expect(request_setting.reload.name).to eq(name)
  end
end
