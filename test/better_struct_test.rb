require "better_struct"
require "minitest/autorun"
require "pry"

class BetterStructTest < Minitest::Test
  def test_maybe_monad
    better_struct = BetterStruct.new(nil)

    assert_equal better_struct.some_method, better_struct
  end

  def test_result_wrapping
    assert_equal BetterStruct.new("foobar")[0..2], BetterStruct.new("foo")
  end

  def test_getting_value
    better_struct = BetterStruct.new("foobar")

    assert_equal better_struct.value, "foobar"
  end

  def test_unwrapped_to_s_method
    better_struct = BetterStruct.new(1)

    assert_equal better_struct.to_s, "1"
  end

  def test_block_argument_wrapping
    better_struct = BetterStruct.new([3, 2, 1])

    better_struct.each_with_index do |val, i|
      assert val.is_a?(BetterStruct)
      assert val.value.is_a?(Integer)
      assert i.is_a?(BetterStruct)
      assert i.value.is_a?(Integer)
    end
  end

  def test_hash_methods
    better_struct = BetterStruct.new({ "FooBar1" => { foo_bar2: "Hello World!" } })

    assert_equal better_struct.foo_bar1.foo_bar2, BetterStruct.new("Hello World!")
  end
end
