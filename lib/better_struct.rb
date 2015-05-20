require "set"
require_relative "./better_struct/version"
require_relative "./better_struct/methodize"

class BetterStruct
  EQUAL_SIGN = "=".freeze
  MAP_METHOD_NAMES = %i(map map!).to_set.freeze

  attr_reader :value

  def initialize(value = nil)
    @value = value
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
    value.respond_to?(:empty?) ? !!value.empty? : !value
  end

private

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

  def method_missing(method_name, *args, &block)
    if value.respond_to?(method_name)
      __delegate_method(method_name, *args, &block)
    elsif __assignment?(method_name) && __defined_methods
      @__defined_methods[__methodize(method_name[0...-1])] = args.first
    else
      __wrap(__defined_methods[method_name.to_s])
    end
  end

  def __assignment?(method_name)
    method_name[-1] == EQUAL_SIGN
  end

  def __defined_methods
    @__defined_methods ||= begin
      result = {}

      if value && value.respond_to?(:each_pair)
        value.each_pair { |key, v| result[__methodize(key.to_s)] = v }
      end

      result
    end
  end

  def __delegate_method(method_name, *args, &block)
    result = value.public_send(method_name, *__unwrap_items(args), &__wrap_block_args(&block))

    if MAP_METHOD_NAMES.include?(method_name)
      __wrap(__unwrap_items(result))
    else
      __wrap(result)
    end
  end

  def __unwrap_items(items)
    if items.is_a?(Array)
      items.map! { |item| item.is_a?(self.class) ? item.value : item }
    else
      items
    end
  end
end
