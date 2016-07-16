# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a logger' do
    name = SecureRandom.hex(8)

    logger = client.loggers.s3.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
    )

    expect(logger.name).to eq(name)
    expect(logger.reload.name).to eq(name)
  end

  describe 'with a logger' do
    let!(:logger) { a_logger(version: version) }
    let!(:service) { version.service }

    it 'fetches the logger' do
      expect(
        client.loggers(service_id: version.service_id,
                       version_number: version.number,
                       type: logger.type).get(logger.identity)
      ).to eq(logger)
    end

    it 'lists loggers' do
      expect(client.loggers(service_id: version.service_id,
                            version_number: version.number,
                            type: logger.type)).to include(logger)
    end

    it 'updates a logger' do
      path = SecureRandom.hex(6)

      logger.update(path: path)

      expect(logger.path).to eq(path)
      expect(logger.reload.path).to eq(path)
    end

    it 'destroys a logger' do
      logger.destroy

      expect(logger.reload).to eq(nil)
    end
  end
end
