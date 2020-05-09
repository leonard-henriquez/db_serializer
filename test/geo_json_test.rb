# frozen_string_literal: true

require 'test_helper'

class GeoJSONTest < ActiveSupport::TestCase
  test 'to_geojson should return a valid GeoJSON' do
    cities = City.all
    assert cities.count.positive?

    json = cities.to_geojson(['name'])

    # checks if parsable JSON with a features key
    hash = JSON.parse(json)
    assert hash.is_a?(Hash) && hash.key?('features')

    # checks if features is an array
    features = hash['features']
    assert features.is_a?(Array)

    # checks if first feature as a geometry, type and properties
    feature = features.first
    assert feature.is_a?(Hash)
    assert feature.key?('geometry') && feature.key?('type') && feature.key?('properties')
    assert_equal 'Feature', feature['type']

    # checks if properties as a name
    properties = feature['properties']
    assert properties.is_a?(Hash) && properties.key?('name')
    assert_equal cities.first.name, properties['name']

    # checks if geometry as a type and coordinates
    geometry = feature['geometry']
    assert geometry.is_a?(Hash) && geometry.key?('type') && geometry.key?('coordinates')
    assert_equal 'Polygon', geometry['type']
  end
end
