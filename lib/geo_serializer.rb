# frozen_string_literal: true

require 'active_support'
require 'active_record'

module GeoSerializer
  extend ActiveSupport::Autoload

  autoload :Version
  autoload :JSON
  autoload :Utilities
end
