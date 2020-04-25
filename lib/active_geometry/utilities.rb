# frozen_string_literal: true

module ActiveGeometry
  # Module defining miscellaneous tools
  module Utilities
    # SQL utilies
    module SQL
      class << self
        # executes a sql query and take the key `key` of the first record
        # similar to Calculation#pick:
        # https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-pick
        def pick(query, key, default = nil)
          result = ActiveRecord::Base.connection.exec_query(query)
          first_result = result.first
          return default if first_result.nil? || !first_result.key?(key)

          first_result[key]
        end
      end
    end
  end
end
