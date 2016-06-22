# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a director' do
    name = SecureRandom.hex(3)

    director = client.directors.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
    )

    expect(director.name).to eq(name)
    expect(director.reload.name).to eq(name)
  end

  describe 'with a director' do
    let!(:director) { a_director(version: version) }
    let!(:service) { version.service }

    it 'fetches the director' do
      expect(
        client.directors(service_id: version.service_id, version_number: version.number).get(director.identity)
      ).to eq(director)
    end

    it 'lists directors' do
      expect(client.directors(service_id: version.service_id, version_number: version.number)).to include(director)
    end

    it 'updates a director' do
      comment = SecureRandom.hex(6)

      director.update(comment: comment)

      expect(director.comment).to eq(comment)
      expect(director.reload.comment).to eq(comment)
    end

    it 'destroys a director' do
      director.destroy

      expect(director.reload).to eq(nil)
    end
  end
end
