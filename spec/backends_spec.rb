require 'spec_helper'

RSpec.describe "Backends" do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it "creates a backend" do
    hostname = "#{SecureRandom.hex(3)}.example-#{SecureRandom.hex(3)}.com"
    name = SecureRandom.hex(3)


    backend = client.backends.create(
                                     service_id: service.id,
                                     version_number: version.number,
                                     name: name,
                                     hostname: hostname,
                                    )

    expect(backend.name).to eq(name)
    expect(backend.hostname).to eq(hostname)
    expect(backend.reload.name).to eq(name)
    expect(backend.hostname).to eq(hostname)
  end

  describe "with a backend" do
    let!(:backend) { a_backend(version: version) }
    let!(:service) { version.service }

    it "fetches the backend" do
      expect(
        client.backends(service_id: version.service_id, version_number: version.number).get(backend.identity)
      ).to eq(backend)
    end

    it "lists backends" do
      expect(client.backends(service_id: version.service_id, version_number: version.number)).to include(backend)
    end

    it "updates a backend" do
      comment = SecureRandom.hex(6)

      backend.update(comment: comment)

      expect(backend.comment).to eq(comment)
      expect(backend.reload.comment).to eq(comment)
    end

    #it "clones a version" do
      #expected_number = service.versions.map(&:number).max + 1
      #new_version = version.clone!

      #expect(new_version.number).to eq(expected_number)
      #expect(new_version.service).to eq(service)
    #end

    #it "validates a version" do
      #response = version.validate

      #expected_response = if version.domains.none?
                         #[false, "Version has no associated domains"]
                       #else
                         #[true, nil]
                       #end

      #expect(response).to eq(expected_response)
    #end
  #end

  #describe "with an unlocked version" do
    #let!(:version) { viable_version(locked: false) }

    #it "activates" do
      #expect {
        #version.lock!
      #}.to change(version, :locked).from(false).to(true)

      #expect(version.reload).to be_locked
    #end
  #end

  #describe "with a deactivated version" do
    #let!(:version) { viable_version(active: false) }

    #it "activates" do
      #expect {
        #version.activate!
      #}.to change(version, :active).from(false).to(true)

      #expect(version.reload).to be_active
    #end
  #end

  #describe "with an activated version" do
    #let!(:version) { viable_version(active: true) }

    #it "deactivates" do
      #expect {
        #version.deactivate!
      #}.to change(version, :active).from(true).to(false)

      #expect(version.reload).not_to be_active
    #end
  end
end
