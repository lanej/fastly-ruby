# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let!(:acl)     { a_acl }
  let!(:service) { acl.service }

  it 'creates a acl entry' do
    ip = Faker::Internet.ip_v4_address

    entry = acl.entries.create(ip: ip)

    expect(entry.ip).to eq(ip)
    expect(entry.service_id).to eq(service.id)
    expect(entry.service).to eq(service)
    expect(entry.acl_id).to eq(acl.id)

    entry.reload

    expect(entry.ip).to eq(ip)
    expect(entry.service_id).to eq(service.id)
    expect(entry.service).to eq(service)
    expect(entry.acl_id).to eq(acl.id)
  end

  describe 'with a acl entry' do
    let!(:acl_entry) do
      acl.entries.first || acl.entries.create(ip: Faker::Internet.ip_v4_address)
    end

    it 'updates the ip' do
      old_ip = acl_entry.ip
      new_ip = Faker::Internet.ip_v4_address

      expect do
        acl_entry.update(ip: new_ip)
      end.to change(acl_entry, :ip).from(old_ip).to(new_ip)
        .and change { acl.entries.get(acl_entry.id).ip }.from(old_ip).to(new_ip)
    end

    it 'destroys' do
      expect do
        acl_entry.destroy
      end.to change { acl_entry.reload }.to(nil)
    end
  end
end
