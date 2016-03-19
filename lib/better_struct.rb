require "set"
require_relative "./better_struct/version"
require_relative "./better_struct/methodize"

class BetterStruct
  EQUAL_SIGN = "=".freeze
  MAP_METHOD_NAMES = %w(map map!).to_set.freeze

  attr_reader :value

  def initialize(value = nil)
    @value = value
    __load_defined_methods
  end

  def ==(other)
    other.is_a?(self.class) && value == other.value
  end

  def inspect
    "#{ self.class }<#{ value.inspect }>"
  end

  def to_s
    value.to_s
  end

  def empty?
    value.respond_to?(:empty?) ? value.empty? : !value
  end

private

  def __load_defined_methods
    @__defined_methods = {}

    if value && value.respond_to?(:each_pair)
      value.each_pair { |k, v| @__defined_methods[__methodize(k)] = v }
    end
  end

  def method_missing(method_name, *args, &block)
    method_name = method_name.to_s

    if value.respond_to?(method_name)
      __delegate_method(method_name, *args, &block)
    elsif __assignment?(method_name)
      @__defined_methods[method_name[0...-1]] = args.first
    else
      __wrap(@__defined_methods[method_name])
    end
  end

  def __assignment?(method_name)
    method_name[-1] == EQUAL_SIGN
  end

  def __delegate_method(method_name, *args, &block)
    result = value.public_send(method_name, *__unwrap_items(args), &__wrap_block_args(&block))
    result = __unwrap_items(result) if MAP_METHOD_NAMES.include?(method_name)

    __wrap(result)
  end

  def __wrap(value)
    value.is_a?(self.class) ? self : self.class.new(value)
  end

  def __wrap_block_args
    return unless block_given?

    Proc.new do |*args|
      wrapped_arguments = args.map! { |arg| __wrap(arg) }
      yield(*wrapped_arguments)
    end
  end

  def __unwrap_items(items)
    items.is_a?(Array) ? items.map! { |i| __unwrap(i) } : items
  end

  def __unwrap(value)
    value.is_a?(self.class) ? value.value : value
  end
end
