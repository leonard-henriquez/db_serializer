# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'db_serializer'
require 'minitest/autorun'

# Connect database
ActiveRecord::Base.establish_connection(
  adapter: 'postgis',
  database: 'db_serializer_test'
)

# Reset schema
ActiveRecord::Schema.define do
  enable_extension 'postgis'

  create_table :cities, force: true do |t|
    t.string :name
    t.geometry :geometry
  end
end

# Create dummy model
class City < ActiveRecord::Base
  include DbSerializer::GeoJSON

  db_serializer :geometry
end

# Seed
coords = [
  '2.2707366943359375 48.81296811706886',
  '2.4200820922851562 48.81296811706886',
  '2.4200820922851562 48.892261018889236',
  '2.2707366943359375 48.892261018889236',
  '2.2707366943359375 48.81296811706886'
]

City.create(
  name: 'Paris',
  geometry: "POLYGON ((#{coords.join(',')}))"
)
