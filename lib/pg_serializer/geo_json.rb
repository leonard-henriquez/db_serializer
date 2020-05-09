# frozen_string_literal: true

module PgSerializer
  # JSON Serializer
  module GeoJSON
    extend ActiveSupport::Concern

    included do
      @pg_serializer_options = {
        field: :geometry
      }

      private

      ##
      # Adds a geojson attribute to the current ActiveRecord::Relation
      # @param columns [Array<Symbol, String>] list of the columns to include in the GeoJSON
      # @return [ActiveRecord::Relation] relation with a new attribute named geojson
      scope :set_geojson_attribute, ->(columns = nil) do
        columns = select_values if columns.nil?
        params = {
          geometry_column: pg_serializer_options[:field],
          field_name: :geojson
        }

        attribute = PgSerializer::Utilities::SQL.geojson_attribute(columns, params)

        _select!(attribute)
      end
    end

    class_methods do
      ##
      # Allows to set the options for this gem
      # @param field [Symbol] name of the attribute containing geometry
      # @return [Hash]
      def pg_serializer(field = :geometry)
        @pg_serializer_options = {}
        @pg_serializer_options[:field] = field.to_sym
        pg_serializer_options
      end

      ##
      # Allows to get the options for this gem
      # @return [Hash] contains keys :field
      def pg_serializer_options
        if defined?(@pg_serializer_options)
          @pg_serializer_options
        elsif superclass.respond_to?(:pg_serializer_options)
          superclass.pg_serializer_options || {}
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
        query = PgSerializer::Utilities::SQL.feature_collection(features)
        ActiveRecord::Base.connection.query_value(query)
      end
    end
  end
end
