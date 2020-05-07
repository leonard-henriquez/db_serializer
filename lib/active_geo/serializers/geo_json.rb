# frozen_string_literal: true

##
# Module to add spatial methods to ActiveRecord models.
# The extended class must be an ActiveRecord::Base.
# It must also have a geometry field.
module ActiveGeo::Serializers
  module GeoJSON
    extend ActiveSupport::Concern

    DEFAULT_BOUNDING = 0

    included do
      @geometrable_options = {
        field: :geometry,
        srid: 4326
      }

      private

      ##
      # Adds a geojson attribute to the current ActiveRecord::Relation
      # @private
      # @param columns [Array<Symbol, String>] list of the columns to include in the GeoJSON
      # @return [ActiveRecord::Relation] relation with a new attribute named geojson
      scope :set_geojson_attribute, ->(columns = nil) do
        columns = select_values if columns.nil?
        params = {
          geometry_column: geometrable_options[:field],
          field_name: :geojson
        }

        attribute = ActiveGeo::GeoUtilities::SQL.geojson_attribute(columns, params)

        _select!(attribute)
      end
    end

    class_methods do
      ##
      # Allows to set the options for this gem
      # @param field [Symbol] name of the attribute containing geometry
      # @param options [Hash] other options such as srid
      # @return [Hash]
      def geometry_on(field = :geometry, options = {})
        srid = attribute_types[field.to_s].spatial_factory.srid
        @geometrable_options = options
        @geometrable_options[:srid] ||= srid
        @geometrable_options[:field] = field.to_sym
        geometrable_options
      end

      ##
      # Allows to get the options for this gem
      # @return [Hash] contains keys :field, :srid
      def geometrable_options
        if defined?(@geometrable_options)
          @geometrable_options
        elsif superclass.respond_to?(:geometrable_options)
          superclass.geometrable_options || {}
        else
          {}
        end
      end

      ##
      # Creates a json serialized FeatureCollection of the ActiveRecord::Relation.
      #
      # FeatureCollection specs: http://wiki.geojson.org/GeoJSON_draft_version_6#FeatureCollection
      #
      # It is already serialized so there is no need to apply +.to_json+.
      #
      # @param columns [Array<Symbol, String>]
      # @return [String] JSON serialized FeatureCollection
      def to_geojson(columns = nil)
        features = set_geojson_attribute(columns)
        query = ActiveGeo::GeoUtilities::SQL.feature_collection(features)
        ActiveRecord::Base.connection.query_value(query)
      end
    end
  end
end
