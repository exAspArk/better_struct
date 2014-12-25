# BetterStruct

Use your data without pain.
It behaves like OpenStruct with monads. Look at the examples below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'better_struct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_struct

## Usage

#### Maybe monad

```ruby
BetterStruct.new(nil) == BetterStruct.new(nil).some_method # => true
```

#### Everything is wrapped

```ruby
better_struct = BetterStruct.new("foobar")

better_struct[0..2].is_a?(BetterStruct)        # => true
better_struct[0..2] == BetterStruct.new("foo") # => true
```

```ruby
better_struct = BetterStruct.new([1, 2, 3])

result = better_struct.all? { |i| i.is_a?(BetterStruct) }

result.is_a?(BetterStruct)       # => true
result == BetterStruct.new(true) # => true

```

#### Like OpenStruct

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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/better_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
