class Fastly::Backends
  include Fastly::Collection

  model Fastly::Backend

  attribute :service_id
  attribute :version_number, type: :integer

  def all
    requires :service_id, :version_number

    load(
      cistern.get_backends(service_id, version_number).body
    )
  end

  def get(identity)
    requires :service_id, :version_number

    new(
      cistern.get_backend(service_id, version_number, identity).body
    )
  end

  def new(new_attributes={})
    super(attributes.merge(new_attributes))
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end

end
