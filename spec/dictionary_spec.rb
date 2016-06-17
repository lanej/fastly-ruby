# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Dictionary' do
  it 'creates a dictionary' do
    version = a_version

    name = "f" + SecureRandom.hex(3)
    expect(
      version.dictionaries.create(name: name).identity
    ).not_to be_nil
  end

  #describe 'with a dictionary' do
    #let!(:dictionary) { a_dictionary(locked: false) }
    #let!(:service) { dictionary.service }

    #it 'fetches the dictionary' do
      #expect(client.dictionaries(service_id: dictionary.service_id).get(dictionary.identity)).to eq(dictionary)
    #end

    #it 'lists dictionaries' do
      #expect(client.dictionaries(service_id: a_dictionary.service_id)).to include(dictionary)
    #end

    #it 'updates a dictionary' do
      #comment = SecureRandom.hex(6)

      #dictionary.update(comment: comment)

      #expect(dictionary.comment).to eq(comment)
      #expect(dictionary.reload.comment).to eq(comment)
    #end
  #end
end
