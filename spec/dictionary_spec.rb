# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Dictionary' do
  it 'creates a dictionary' do
    version = a_version

    name = 'f' + SecureRandom.hex(3)
    expect(
      version.dictionaries.create(name: name).identity
    ).not_to be_nil
  end

  describe 'with a dictionary' do
    let!(:dictionary) { a_dictionary }

    it 'fetches the dictionary' do
      expect(
        client.dictionaries(service_id: dictionary.service_id, version_number: dictionary.version_number)
        .get(dictionary.name)
      ).to eq(dictionary)
    end

    it 'lists dictionaries' do
      expect(
        client.dictionaries(service_id: dictionary.service_id, version_number: dictionary.version_number)
      ).to include(dictionary)
    end

    it 'updates a dictionary' do
      name = "fst_" + SecureRandom.hex(6)

      dictionary.update(name: name)

      expect(dictionary.name).to eq(name)
      expect(dictionary.reload.name).to eq(name)
    end
  end
end
