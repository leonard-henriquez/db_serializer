# frozen_string_literal: true

require 'active_support'
require 'active_record'

##
# Module that contains spatial serializers for ActiveRecord models.
# The extended class must be an ActiveRecord::Base.
# It must also have a geometry column (the name of this column can be customized).
module PgSerializer
  extend ActiveSupport::Autoload

  autoload :Version
  autoload :GeoJSON
  autoload :Utilities
end
