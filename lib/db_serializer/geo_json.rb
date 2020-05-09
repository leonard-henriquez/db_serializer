# frozen_string_literal: true

module DbSerializer
  # JSON Serializer
  module GeoJSON
    extend ActiveSupport::Concern

    included do
      @db_serializer_options = {
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
          geometry_column: db_serializer_options[:field],
          field_name: :geojson
        }

        attribute = DbSerializer::Utilities::SQL.geojson_attribute(columns, params)

        _select!(attribute)
      end
    end

    class_methods do
      ##
      # Allows to set the options for this gem
      # @param field [Symbol] name of the attribute containing geometry
      # @return [Hash]
      def db_serializer(field = :geometry)
        @db_serializer_options = {}
        @db_serializer_options[:field] = field.to_sym
        db_serializer_options
      end

      ##
      # Allows to get the options for this gem
      # @return [Hash] contains keys :field
      def db_serializer_options
        if defined?(@db_serializer_options)
          @db_serializer_options
        elsif superclass.respond_to?(:db_serializer_options)
          superclass.db_serializer_options || {}
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
        query = DbSerializer::Utilities::SQL.feature_collection(features)
        ActiveRecord::Base.connection.query_value(query)
      end
    end
  end
end
