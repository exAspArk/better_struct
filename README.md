# BetterStruct

[![Build Status](https://travis-ci.org/exAspArk/better_struct.svg)](https://travis-ci.org/exAspArk/better_struct)

**BetterStruct** is a data structure which allows you to use your data without pain.

It behaves like an OpenStruct on steroids with monad.

```ruby
hash = { "FooBar1" => { foo_bar2: "Hello World!" } }

# Instead of this:
if hash["FooBar1"] && hash["FooBar1"][:foo_bar2] && hash["FooBar1"][:foo_bar2].respond_to?(:sub)
  hash["FooBar1"][:foo_bar2].sub("Hello ", "") # => "World!"
end

# Simply use:
BetterStruct.new(hash).foo_bar1.foo_bar2.sub("Hello ", "").value # => "World!"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "better_struct"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_struct

## Usage

#### Maybe monad

```ruby
BetterStruct.new(nil) == BetterStruct.new(nil).this_method.does_not_exist # => true
```

#### Everything is wrapped

```ruby
better_struct = BetterStruct.new("foobar")

better_struct[0..2] == BetterStruct.new("foo") # => true
```

```ruby
better_struct = BetterStruct.new([1, 2, 3])

better_struct.all? { |i| i.is_a?(BetterStruct) } == BetterStruct.new(true) # => true
```

#### Like OpenStruct on steroids

```ruby
some_hash = { "FooBar1" => { foo_bar2: "Hello World!" } }
better_struct = BetterStruct.new(some_hash)

better_struct.foo_bar1.foo_bar2 == BetterStruct.new("Hello World!") # => true
```

#### Leaving the monad

```ruby
better_struct = BetterStruct.new("foobar")

better_struct.gsub("foo", "super-").value == "super-foo" # => true

```

## Testing

    $ ruby -Ilib:test test/better_struct_test.rb

## Benchmarking

Not slower than OpenStruct:

```
$ ruby scripts/benchmark.rb

Calculating -------------------------------------
          OpenStruct     6.562k i/100ms
        BetterStruct     7.155k i/100ms
-------------------------------------------------
          OpenStruct     75.194k (± 7.4%) i/s -    374.034k
        BetterStruct     76.987k (± 6.7%) i/s -    386.370k

Comparison:
        BetterStruct:    76986.7 i/s
          OpenStruct:    75193.6 i/s - 1.02x slower
```

## Contributing

1. Fork it ( https://github.com/exAspArk/better_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
