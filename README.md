# fastly-ruby

Ruby Client Wrapper for the Fastly API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fastly', '~> 2.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fastly

## Usage


### Authentication

Using [tokens](https://docs.fastly.com/api/auth#tokens).

```ruby
fastly = Fastly.new(token: "7601336ecb649ea53f6016f3ee0ea55980b803e9")
```

Using username / password

```ruby
fastly = Fastly.new(username: "jlane@fastly.com", password: "password")
```


### Examples

```ruby
services = fastly.services.all          # list services
service  = fastly.services.get(name)    # get a service
versions = service.versions.all         # list versions for a service
version  = service.versions.get(number) # get a version via service

# get a version directly
version = fastly.versions(service_id: "41yx1aD1FKtapOjKVa0Dtc").get(1)

# get a version directly without the model
response = fastly.get_version("41yx1aD1FKtapOjKVa0Dtc", 1) #=> #<Fastly::Response>
response.status #=> 200
response.headers #=>
{
            "status" => "200 OK",
      "content-type" => "application/json",
     "cache-control" => "no-cache",
               "via" => "1.1 varnish, 1.1 varnish",
    "content-length" => "176",
              "date" => "Tue, 19 Jul 2016 23:14:13 GMT",
        "connection" => "close",
       "x-served-by" => "app-stg-sjc3543-STG, cache-stg-sjc3546-STG",
           "x-cache" => "MISS, MISS",
      "x-cache-hits" => "0, 0",
           "x-timer" => "S1468970053.530374,VS0,VE116",
              "vary" => "Accept-Encoding"
}
response.body #=>
{
       "testing" => false,
        "locked" => false,
        "number" => 1,
        "active" => false,
    "service_id" => "41yx1aD1FKtapOjKVa0Dtc",
       "staging" => false,
    "created_at" => "2016-07-18T18:36:18+00:00",
    "deleted_at" => nil,
       "comment" => "",
    "updated_at" => "2016-07-18T18:36:18+00:00",
      "deployed" => false
}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fastly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

