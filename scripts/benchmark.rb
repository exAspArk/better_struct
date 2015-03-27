require "benchmark/ips"
require "ostruct"
require_relative "../lib/better_struct"

Benchmark.ips do |x|
  x.report "OpenStruct" do
    object = OpenStruct.new(name: "John")
    object.name
    object.arr = [1, 2, 3, 4, 5]
    object.arr.any? { |i| i > 3 }
  end

  x.report "BetterStruct" do
    object = BetterStruct.new(name: "John")
    object.name
    object.arr = [1, 2, 3, 4, 5]
    object.arr.any? { |i| i > 3 }
  end

  x.compare!
end
