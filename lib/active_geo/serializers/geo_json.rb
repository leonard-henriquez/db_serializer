# frozen_string_literal: true

# Concern for spatial methods
# The extended class must be an ActiveRecord::Base.
# It must also have a geometry field.
module ActiveGeo
  module Serializers
    module GeoJSON
      extend ActiveSupport::Concern

      # constants
      DEFAULT_BOUNDING = 0

      included do
        @geometrable_options = {
          field: :geometry,
          srid: 4326
        }

        # Filters only zones in between the min_lng, min_lat, max_lng, max_lat
        scope :in_bounds, ->(params) do
          srid = geometrable_options[:srid]
          field = geometrable_options[:field]

          bounding_box = GeoUtilities.bounding_box(params, srid)
          return all unless bounding_box

          bounding_box_geometry = bounding_box.to_geometry
          dist = params[:bounding] || DEFAULT_BOUNDING
          where("ST_DWithin(geography(?), geography(#{field}), ?)", bounding_box_geometry, dist)
        end

        private

        # Adds a geo_json field
        scope :set_geojson_attribute, ->(columns = nil) do
          columns = select_values if columns.nil?
          params = { geometry_column: geometrable_options[:field] }

          geo_json_field = GeoUtilities::SQL.geo_json_field(columns, params)

          _select!(geo_json_field)
        end
      end

      class_methods do
        def geometry_on(field = :geometry, options = {})
          srid = attribute_types[field.to_s].spatial_factory.srid
          @geometrable_options = options
          @geometrable_options[:srid] ||= srid
          @geometrable_options[:field] = field
        end

        def geometrable_options
          if defined?(@geometrable_options)
            @geometrable_options
          elsif superclass.respond_to?(:geometrable_options)
            superclass.geometrable_options || {}
          else
            {}
          end
        end

        # Returns a string containing a FeatureCollection.
        # FeatureCollection specs: http://wiki.geojson.org/GeoJSON_draft_version_6#FeatureCollection
        # It is already serialized so there is no need to apply `.to_json`.
        def to_geojson(columns = nil)
          features = set_geojson_attribute(columns)
          query = GeoUtilities::SQL.feature_collection(features)
          ActiveRecord::Base.connection.query_value(query)
        end
      end
    end
  end
end
