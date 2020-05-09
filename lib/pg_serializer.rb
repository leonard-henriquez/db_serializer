# frozen_string_literal: true

require 'active_support'
require 'active_record'

module PgSerializer
  extend ActiveSupport::Autoload

  autoload :Version
  autoload :GeoJSON
  autoload :Utilities
end
