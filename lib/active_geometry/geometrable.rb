# frozen_string_literal: true

# concern for spatial methods
# the extended class must be an ActiveRecord::Base
# it must also have a geometry field
module ActiveGeometry
  module Geometrable
    extend ActiveSupport::Concern

    # constants
    DEFAULT_BOUNDING = 0

    included do
      attribute :geo_json, :string

      # filters only zones in between the min_lng, min_lat, max_lng, max_lat
      scope :in_bounds, ->(params) do
        bounding_box = GeoUtilities.bounding_box(params)
        return all unless bounding_box

        bounding_box_geometry = bounding_box.to_geometry
        dist = params[:bounding] || DEFAULT_BOUNDING
        where('ST_DWithin(geography(?), geography(geometry), ?)', bounding_box_geometry, dist)
      end

      # adds a geo_json field
      scope :add_geo_json_field, ->(columns = []) do
        geo_json_field = GeoUtilities::SQL.geo_json_field(columns)
        select_append(geo_json_field)
      end

      # returns a string containing a FeatureCollection
      # FeatureCollection specs: http://wiki.geojson.org/GeoJSON_draft_version_6#FeatureCollection
      # it is already serialized so there is no need to apply .to_json
      def self.feature_collection(columns = [])
        features = add_geo_json_field(columns)
        query = GeoUtilities::SQL.feature_collection(features)
        Utilities::SQL.pick(query, 'json', '{}')
      end
    end
  end
end
