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

  describe 'with a gzip' do
    let!(:gzip) { a_gzip(version: version) }
    let!(:service) { version.service }

    it 'fetches the gzip' do
      expect(
        client.gzips(service_id: version.service_id, version_number: version.number).get(gzip.identity)
      ).to eq(gzip)
    end

    it 'lists gzips' do
      expect(client.gzips(service_id: version.service_id, version_number: version.number)).to include(gzip)
    end

    it 'updates a gzip' do
      content_types = "application/json+#{SecureRandom.hex(3)}"

      gzip.update(content_types: content_types)

      expect(gzip.content_types).to eq(content_types)
      expect(gzip.reload.content_types).to eq(content_types)
    end

    it 'destroys a gzip' do
      gzip.destroy

      expect(gzip.reload).to eq(nil)
    end
  end
end
