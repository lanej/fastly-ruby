# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Versions' do
  it 'creates a version' do
    service = a_service
    latest = service.versions.last
    version = service.versions.create

    expect(version.number).to eq(latest.number + 1)
  end

  describe 'with a version' do
    let!(:version) { a_version(locked: false) }
    let!(:service) { version.service }

    it 'fetches the version' do
      expect(client.versions(service_id: version.service_id).get(version.identity)).to eq(version)
    end

    it 'lists versions' do
      expect(client.versions(service_id: a_version.service_id)).to include(version)
    end

    it 'updates a version' do
      comment = SecureRandom.hex(6)

      version.update(comment: comment)

      expect(version.comment).to eq(comment)
      expect(version.reload.comment).to eq(comment)
    end

    it 'clones a version' do
      expected_number = service.versions.map(&:number).max + 1
      new_version = version.clone!

      expect(new_version.number).to eq(expected_number)
      expect(new_version.service).to eq(service)
    end

    it 'validates a version' do
      response = version.validate

      expected_response = if version.domains.none?
                            [false, 'Version has no associated domains']
                          else
                            [true, nil]
                          end

      expect(response).to eq(expected_response)
    end
  end

  describe 'with an unlocked version' do
    let!(:version) { viable_version(locked: false) }

    it 'activates' do
      expect do
        version.lock!
      end.to change(version, :locked).from(false).to(true)

      expect(version.reload).to be_locked
    end
  end

  describe 'with a deactivated version' do
    let!(:version) { viable_version(active: false) }

    it 'activates' do
      expect do
        version.activate!
      end.to change(version, :active).from(false).to(true)

      expect(version.reload).to be_active
    end
  end

  describe 'with an activated version' do
    let!(:version) { viable_version(active: true) }

    it 'deactivates' do
      expect do
        version.deactivate!
      end.to change(version, :active).from(true).to(false)

      expect(version.reload).not_to be_active
    end
  end
end
