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

  def test_map_result
    better_struct = BetterStruct.new([1, 2, 3])

    mapped = better_struct.map do |i|
      assert i.is_a?(BetterStruct)
      i
    end

    mapped.value.each do |i|
      assert !i.is_a?(BetterStruct)
    end
  end

  def test_equality
    assert BetterStruct.new(1) == BetterStruct.new(1.0)
    assert BetterStruct.new(1) != 1
  end

  def test_underscoring_methods
    assert BetterStruct.new({ "Word With-Space" => 1 }).word_with_space.value == 1
  end
end
