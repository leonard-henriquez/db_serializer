# frozen_string_literal: true

require 'test_helper'

class DbSerializerTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    assert_not_nil DbSerializer::VERSION
  end
end
