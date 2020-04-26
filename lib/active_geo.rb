# frozen_string_literal: true

require 'active_support'
require 'active_record'
require 'active_geo/version'

module ActiveGeo
  extend ActiveSupport::Autoload

  autoload :QueryMethods
  autoload :Geometrable
  autoload :Utilities
  autoload :GeoUtilities

  ActiveRecord::Relation.include ActiveGeo::QueryMethods
  ActiveRecord::QueryMethods.include ActiveGeo::QueryMethods
  # ActiveRecord::Base.include ActiveGeo::Geometrable
end
