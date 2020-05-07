# Active Geometry

This gem provide a simple way to serialize Active Record models to GeoJSON objects.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geo_serializer'
```

And then execute:

```bash
$ bundle install
```

Then you need to include the concern `GeoSerializer::JSON` to your model:

```ruby
# In this example the Cities model has:
# - an attribute name of type string
# - an attribute boundaries of type geometry
class Cities < ActiveRecord::Base
  # Include this concern
  include GeoSerializer::JSON

  # Specify which column contains the geometry
  # If you don't specify it, by default it will be :geometry
  geo_serializer :boundaries
end
```

## Usage

```ruby
puts Cities.all.to_geojson([:id, :name])

# If you had such a model, it would output something like this:
# {
#   "type": "FeatureCollection", "features": [{
#     "id": 1, "type": "Feature", "geometry": {
#       "type": "MultiLineString", "coordinates": [[[x1,y1],[x2,y2]]]
#     },
#     "properties": {"id": 1, "name": "Paris"}
#   }]
# }
```
Note: the output has been pretty printed for readability but please keep in mind that `to_geojson` returns a *string* containing a valid serialized JSON.
It means that you do not need to use `to_json` on it and that it can be parse with `JSON.parse`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leonard-henriquez/geo_serializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/leonard-henriquez/geo_serializer/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the geo_serializer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/leonard-henriquez/geo_serializer/blob/master/CODE_OF_CONDUCT.md).
