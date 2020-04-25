# frozen_string_literal: true

module ActiveGeo
  module QueryMethods
    extend ActiveSupport::Concern

    included do
      def select_append(*fields)
        fields.unshift(arel_table[Arel.star]) if select_values.none?
        select(*fields)
      end
    end
  end
end
