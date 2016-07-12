# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a acl' do
    name = 'fst_' + SecureRandom.hex(6)

    acl = client.acls.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
    )

    expect(acl.name).to eq(name)
    expect(acl.reload.name).to eq(name)
  end

  describe 'with a acl' do
    let!(:acl) { a_acl(version: version) }
    let!(:service) { version.service }

    it 'fetches the acl' do
      expect(
        client.acls(service_id: version.service_id, version_number: version.number).get(acl.identity)
      ).to eq(acl)
    end

    it 'lists acls' do
      expect(client.acls(service_id: version.service_id, version_number: version.number)).to include(acl)
    end

    it 'updates a acl' do
      name = 'fst_' + SecureRandom.hex(6)

      acl.update(name: name)

      expect(acl.name).to eq(name)
      expect(acl.reload.name).to eq(name)
    end

    it 'destroys a acl' do
      acl.destroy

      expect(acl.reload).to eq(nil)
    end
  end
end
