# frozen_string_literal: true

require "active_geometry/version"

module ActiveGeometry
  extend ActiveSupport::Autoload

  autoload :Geometrable
  autoload :Utilities

  ActiveRecord::Base.send(:include, ActiveGeometry::Geometrable)
end
