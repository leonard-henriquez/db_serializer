# frozen_string_literal: true

require 'active_support'
require 'active_record'
require 'active_geo/version'

module ActiveGeo
  extend ActiveSupport::Autoload

  autoload :GeoUtilities

  module Serializers
    extend ActiveSupport::Autoload

    autoload :GeoJSON
  end
end
