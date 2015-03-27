require "fileutils"
require "stackprof"
require_relative "../lib/better_struct"

dir = "tmp"
FileUtils.mkdir_p(dir)

filepath = "#{ dir }/stackprof-cpu.dump"

StackProf.run(mode: :cpu, out: filepath) do
  1_000_000.times do
    object = BetterStruct.new(name: "John")
    object.name
    object.arr = [1, 2, 3, 4, 5]
    object.arr.any? { |i| i > 3 }
  end
end

puts `stackprof #{ filepath }`
