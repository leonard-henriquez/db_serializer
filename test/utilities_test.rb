# frozen_string_literal: true

class UtilitiesTest < ActiveSupport::TestCase
  test 'test' do
    assert true
  end
  # test 'geo_json_field' do
  #   result = PgSerializer::Utilities::SQL.geo_json_field([])

  #   id = 1
  #   lng = 2.34741053183924
  #   lat = 48.8587781581108
  #   table = "(SELECT #{id} AS id, geometry('POINT(#{lng} #{lat})')) AS t"
  #   sql = "SELECT #{result} FROM #{table}"

  #   result = Utilities::SQL.pick(sql, 'geo_json')
  #   hash = ActiveSupport::JSON.decode(result)

  #   assert hash.is_a?(Hash)
  #   assert_equal id, hash['id']
  #   assert_equal 'Feature', hash['type']
  #   assert hash['geometry'].is_a?(Hash)
  #   assert_equal 'Point', hash['geometry']['type']

  #   coords = hash['geometry']['coordinates']
  #   factory = RGeo::Geographic.simple_mercator_factory
  #   expected = factory.point(lng, lat)
  #   actual = factory.point(*coords)
  #   assert_in_delta 0, expected.distance(actual), 1e-3
  # end

  # test 'feature_collection with string' do
  #   result = PgSerializer::Utilities::SQL.feature_collection("SELECT '{}'::json AS geo_json")
  #   feature_collection = Utilities::SQL.pick(result, 'json', {})
  #   hash = ActiveSupport::JSON.decode(feature_collection)

  #   assert_equal 'FeatureCollection', hash['type']
  #   assert hash.key?('features')
  # end

  # test 'feature_collection with activerecord_relation' do
  #   sql = MiniTest::Mock.new
  #   sql.expect :to_sql, "SELECT '{}'::json AS geo_json"
  #   sql.expect :is_a?, false, [Object]

  #   feature_collection = ''
  #   ActiveRecord::Relation.stub :new, sql do
  #     query = ActiveRecord::Relation.new
  #     result = PgSerializer::Utilities::SQL.feature_collection(query)
  #     feature_collection = Utilities::SQL.pick(result, 'json', {})
  #   end
  #   hash = ActiveSupport::JSON.decode(feature_collection)

  #   assert_equal 'FeatureCollection', hash['type']
  #   assert hash.key?('features')
  # end
end
