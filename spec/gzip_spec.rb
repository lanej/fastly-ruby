# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a gzip' do
    name = 'fst_' + SecureRandom.hex(6)

    gzip = client.gzips.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
    )

    expect(gzip.name).to eq(name)
    expect(gzip.reload.name).to eq(name)
  end
end
