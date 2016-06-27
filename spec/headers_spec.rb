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

  describe 'with a header' do
    let(:header) { a_header(version: version) }

    it 'updates a header' do
      new_dst = "http.x-fastly-client-#{SecureRandom.hex(6)}"

      copy = header.dup

      expect do
        header.update(dst: new_dst)
      end.to change(header, :dst).from(header.dst).to(new_dst)
        .and change { copy.reload.dst } .from(header.dst).to(new_dst)
    end

    it 'lists headers' do
      expect(version.headers).to include(header)
    end
  end
end
