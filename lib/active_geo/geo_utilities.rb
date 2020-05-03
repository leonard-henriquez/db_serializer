# frozen_string_literal: true

module ActiveGeo
  ##
  # Module defining geographic tools
  module GeoUtilities
    ##
    # SQL utilities for spatial queries
    module SQL
      class << self
        ##
        # Returns a string containing part of a SQL query to get a field named +geojson+.
        # This field is a GeoJSON representation of the +geometry_column+.
        # The GeoJSON will contain the specified +columns+ in its properties.
        # This method should be used in a +SELECT+ statement.
        #
        # Example with sql:
        #   ActiveRecord::Base.connection.exec_query(
        #     "SELECT id, geometry, #{geojson_attribute([:id])} FROM table"
        #   )
        #
        # It will return results with three columns +id+, +geometry+ and +geojson+.
        # The +geojson+ field will be string containing a valid GeoJSON as the example below:
        #   {\"id\": 1, \"type\": \"Feature\", \"geometry\": {\"type\": \"MultiLineString\",
        #   \"coordinates\": [[[x,y]]]}, \"properties\": {\"id\": 555, \"url\": \"paris-75000\"}}
        #
        # Example with an +ActiveRecord::Base+:
        #   record = Model.select(geojson_attribute([:id]))
        #   record.geojson
        #
        # This will return a hash of the GeoJSON because active record automatically casts it.
        #
        # To prevent this behaviour use +record.geojson_before_type_cast+ instead.
        def geojson_attribute(columns, opts = {})
          opts = {
            geometry_column: :geometry,
            field_name: :geojson
          }.merge(opts)

          filtered_columns = columns.reject { |column| column.to_s == opts[:geometry_column].to_s }
          fields = filtered_columns.map { |column| "'#{column}',#{column}" }.join(',')

          geometry = "ST_AsGeoJSON(#{opts[:geometry_column]})::jsonb"
          properties = "json_build_object(#{fields})"
          field_name = opts[:field_name]

          <<-SQL
            jsonb_build_object(
              'type', 'Feature',
              'id', id,
              'geometry', #{geometry},
              'properties', #{properties}
            ) AS #{field_name}
          SQL
        end

        ##
        # Returns a string containing a SQL query.
        #
        # The SQL query returns one line containing only one field.
        # The field is named +json+ and contains a +FeatureCollection+.
        #
        # To learn more about FeatureCollections see the specifications:
        # http://wiki.geojson.org/GeoJSON_draft_version_6#FeatureCollection
        #
        # The features contained in the feature collection are provided by the +features+ parameter.
        # +features+ can be either a raw sql query or an +ActiveRecord::Relation+.
        #
        # Example:
        #   features = Model.select(geojson_attribute([:id]))
        #   query = feature_collection(features)
        #   ActiveRecord::Base.connection.exec_query(query)
        def feature_collection(features, field_name = :geojson)
          inner_query = features.is_a?(String) ? features : features.to_sql

          <<-SQL
            SELECT jsonb_build_object(
              'type', 'FeatureCollection',
              'features', COALESCE(jsonb_agg(features.#{field_name}), '[]')
            ) AS json FROM (#{inner_query}) features
          SQL
        end
      end
    end

    class << self
      ##
      # Returns a +RGeo::Cartesian::BoundingBox+ based on +min_lng+, +min_lat+, +max_lng+, +max_lat+.
      def bounding_box(box, srid = 4326)
        return nil if %i[min_lng min_lat max_lng max_lat].any? { |key| box[key].nil? }

        factory = RGeo::Geographic.spherical_factory(srid: srid)
        min = factory.point(box[:min_lng], box[:min_lat])
        max = factory.point(box[:max_lng], box[:max_lat])

        RGeo::Cartesian::BoundingBox.create_from_points(min, max)
      end
    end
  end
end
