# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it "get a version's setting" do
    settings = version.settings

    expect(settings.default_host).not_to be_nil
    expect(settings.default_ttl).not_to be_nil
  end

  it "updates a version's setting" do
    settings = version.settings

    expect do
      settings.update(default_ttl: 60)
    end.to change { settings.reload.default_ttl }.to(60)
  end
end
