# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version)   { a_version(locked: false) }
  let(:service)   { version.service }
  let(:condition) { a_condition(version: version) }

  it 'creates a request_setting' do
    name = SecureRandom.hex(3)

    request_setting = client.request_settings.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
      condition_name: condition.name,
    )

    expect(request_setting.name).to eq(name)
    expect(request_setting.reload.name).to eq(name)
  end

  describe 'with a request_setting' do
    let!(:request_setting) { a_request_setting(version: version) }

    it 'updates a request_setting' do
      new_name = SecureRandom.uuid

      copy = request_setting.dup

      expect do
        request_setting.update(name: new_name)
      end.to change(request_setting, :name).from(request_setting.name).to(new_name)
        .and change { copy.reload }.to(nil)
    end

    it 'lists request_settings' do
      expect(version.request_settings.all).to include(request_setting)
    end

    it 'destroys a request_setting' do
      expect do
        request_setting.destroy
      end.to change(request_setting, :reload).to(nil)
    end
  end
end
