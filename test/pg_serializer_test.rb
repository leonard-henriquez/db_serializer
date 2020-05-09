# frozen_string_literal: true

require 'test_helper'

class PgSerializerTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    assert_not_nil PgSerializer::VERSION
  end
end
