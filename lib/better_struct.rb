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

  def wrap(value)
    value.is_a?(self.class) ? self : self.class.new(value)
  end

  def wrap_block_args(&block)
    return if block.nil?

    Proc.new do |*args|
      wrapped_arguments = args.map! { |arg| wrap(arg) }
      block.call(*wrapped_arguments)
    end
  end

  def method_missing(method_name, *args, &block)
    if value.respond_to?(method_name)
      delegate_method(method_name, *args, &block)
    elsif assignment?(method_name) && defined_methods
      @defined_methods[methodize(method_name[0...-1])] = args.first
    else
      wrap(defined_methods[method_name.to_s])
    end
  end

  def assignment?(method_name)
    method_name[-1] == EQUAL_SIGN
  end

  def defined_methods
    @defined_methods ||= begin
      result = {}

      if value && value.respond_to?(:each_pair)
        value.each_pair { |key, value| result[methodize(key.to_s)] = value }
      end

      result
    end
  end

  def delegate_method(method_name, *args, &block)
    result = value.public_send(method_name, *unwrap_items(args), &wrap_block_args(&block))

    if MAP_METHOD_NAMES.include?(method_name)
      wrap(unwrap_items(result))
    else
      wrap(result)
    end
  end

  def unwrap_items(items)
    if items.is_a?(Array)
      items.map! { |item| item.is_a?(self.class) ? item.value : item }
    else
      items
    end
  end
end
