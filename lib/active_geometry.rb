# frozen_string_literal: true

require 'active_support'
require 'active_record'
require 'active_geometry/version'

module ActiveGeometry
  extend ActiveSupport::Autoload

  autoload :QueryMethods
  autoload :Geometrable
  autoload :Utilities
  autoload :GeoUtilities

  ActiveRecord::Relation.include ActiveGeometry::QueryMethods
  ActiveRecord::QueryMethods.include ActiveGeometry::QueryMethods
  ActiveRecord::Base.include ActiveGeometry::Geometrable
end
