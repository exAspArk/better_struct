require "better_struct/version"
require "forwardable"

class BetterStruct
  extend Forwardable

  attr_reader :value
  def_delegator :value, :to_s

  def initialize(value)
    @value = value
    @defined_methods = {}

    if value && value.respond_to?(:each_pair)
      value.each_pair { |key, value| @defined_methods[underscore(key.to_s)] = value }
    end
  end

  def ==(other)
    other.is_a?(self.class) && value == other.value
  end

  def inspect
    "#{ self.class }<#{ @value.inspect }>"
  end

private

  def wrap(value)
    value.is_a?(self.class) ? self : self.class.new(value)
  end

  def wrap_block_arguments(*args, &block)
    return if block.nil?

    Proc.new do |*args|
      wrapped_arguments = args.map { |arg| wrap(arg) }
      block.call(*wrapped_arguments)
    end
  end

  def underscore(camel_cased_word)
    return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/

    word = camel_cased_word.to_s.gsub(/::/, '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  def method_missing(*args, &block)
    method_name = args.first.to_s

    if value.respond_to?(method_name)
      result = wrap(value.public_send(*args, &wrap_block_arguments(*args, &block)))

      method_name == "map" ? unwrap_items(result) : result
    else
      wrap(@defined_methods[method_name])
    end
  end

  def unwrap_items(wrapped_array)
    array = wrapped_array.value

    if array
      array_with_unwrapped_items = array.map { |i| i.is_a?(self.class) ? i.value : i }

      wrap(array_with_unwrapped_items)
    else
      wrap(nil)
    end
  end
end
