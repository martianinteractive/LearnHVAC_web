module Shoulda
  module Matchers
    if RUBY_VERSION > "1.9"
      require 'minitest/unit'
      AssertionError = MiniTest::Assertion
    else
      require 'test/unit/assertionfailederror'
      AssertionError = Test::Unit::AssertionFailedError
    end
  end
end
