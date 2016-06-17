# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Domains' do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a domain' do
    name = SecureRandom.hex(3)

    domain = client.domains.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
    )

    expect(domain.name).to eq(name)
    expect(domain.reload.name).to eq(name)
  end

  describe 'with a domain' do
    let!(:domain) { a_domain(version: version) }
    let!(:service) { version.service }

    it 'fetches the domain' do
      expect(
        client.domains(service_id: version.service_id, version_number: version.number).get(domain.identity)
      ).to eq(domain)
    end

    it 'lists domains' do
      expect(client.domains(service_id: version.service_id, version_number: version.number)).to include(domain)
    end

    it 'updates a domain' do
      comment = SecureRandom.hex(6)

      domain.update(comment: comment)

      expect(domain.comment).to eq(comment)
      expect(domain.reload.comment).to eq(comment)
    end

    it 'destroys a domain' do
      domain.destroy

      expect(domain.reload).to eq(nil)
    end
  end
end
