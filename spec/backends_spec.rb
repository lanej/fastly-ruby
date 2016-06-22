# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a backend' do
    hostname = "#{SecureRandom.hex(3)}.example-#{SecureRandom.hex(3)}.com"
    name = SecureRandom.hex(3)

    backend = client.backends.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
      hostname: hostname
    )

    expect(backend.name).to eq(name)
    expect(backend.hostname).to eq(hostname)
    expect(backend.reload.name).to eq(name)
    expect(backend.hostname).to eq(hostname)
  end

  describe 'with a backend' do
    let!(:backend) { a_backend(version: version) }
    let!(:service) { version.service }

    it 'fetches the backend' do
      expect(
        client.backends(service_id: version.service_id, version_number: version.number).get(backend.identity)
      ).to eq(backend)
    end

    it 'lists backends' do
      expect(client.backends(service_id: version.service_id, version_number: version.number)).to include(backend)
    end

    it 'updates a backend' do
      comment = SecureRandom.hex(6)

      backend.update(comment: comment)

      expect(backend.comment).to eq(comment)
      expect(backend.reload.comment).to eq(comment)
    end

    it 'destroys a backend' do
      backend.destroy

      expect(backend.reload).to eq(nil)
    end
  end
end
