require "better_struct"
require "minitest/autorun"
require "pry"

module BetterStructTest
  class MaybeMonad < Minitest::Test
    def test_maybe_monad
      better_struct = BetterStruct.new(nil)

      assert better_struct.some_method == better_struct
    end
  end

  class Wrapping < Minitest::Test
    def test_wrapping
      assert BetterStruct.new("foobar")[0..2] == BetterStruct.new("foo")
    end

    def test_equality
      assert BetterStruct.new(1) == BetterStruct.new(1.0)
      refute BetterStruct.new(1) == 1
    end

    def test_getting_value
      better_struct = BetterStruct.new("foobar")

      assert better_struct.value == "foobar"
    end

    def test_unwrapped_to_s_method
      better_struct = BetterStruct.new(1)

      assert better_struct.to_s == "1"
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
  end

  class LikeOpenStruct < Minitest::Test
    def test_hash_methods
      better_struct = BetterStruct.new({ "FooBar1" => { foo_bar2: "Hello World!" } })

      assert better_struct.foo_bar1.foo_bar2 == BetterStruct.new("Hello World!")
    end

    def test_map_result_unwrapping
      better_struct = BetterStruct.new([1, 2, 3])

      mapped = better_struct.map { |i| i }

      mapped.value.each { |i| refute i.is_a?(BetterStruct) }
    end

    def test_operators
      better_struct = BetterStruct.new([1, 2, 3])

      assert better_struct.map { |i| i * i }.value == [1, 4, 9]
    end

    def test_underscoring_methods
      better_struct = BetterStruct.new({ "Word (With-Space)" => 1 })

      assert better_struct.word_with_space.value == 1
    end

    def test_transliteration
      better_struct = BetterStruct.new({ "Título" => 1 })

      assert better_struct.titulo.value == 1
    end

    def test_new_assignment
      better_struct = BetterStruct.new

      better_struct.head = [1, 2, 3]

      assert better_struct.head == BetterStruct.new([1, 2, 3])
    end

    def test_input_args_immutability
      better_struct = BetterStruct.new(head: [1, 2, 3])
      tail = [4, 5, 6]

      better_struct.head.concat(tail)

      assert better_struct.head == BetterStruct.new([1, 2, 3, 4, 5, 6])
      assert tail == [4, 5, 6]
    end
  end
end
