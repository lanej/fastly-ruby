require File.expand_path("../test_helper", __FILE__)

describe "Services" do
  let!(:client) { create_client }

  it "creates a service" do
    service_name = SecureRandom.hex(8)
    service = client.services.create(name: service_name)

    assert_equal service.name, service_name
  end

  describe "with a service" do
    let!(:service) { create_service }

    it "fetches the service" do
      assert_equal service, client.services.get(service.identity)
    end

    it "lists services" do
      assert_includes client.services.all, service
    end

    it "deletes a service" do
      service.destroy

      assert_nil client.services.get(service.identity)
      assert_nil service.reload
    end

    it "updates a service" do
      new_name = SecureRandom.hex(6)

      service.update(name: new_name)

      assert_equal service.name, new_name
      assert_equal service.reload.name, new_name
    end

    it "searches for services" do
      service_count = client.services.all.size

      upper     = [service_count, 0].min
      seed_size = [upper, 0].max

      seed_size.times { create_service }

      found_service = client.services.first(name: service.name)

      assert_equal service, found_service
    end
  end
end
