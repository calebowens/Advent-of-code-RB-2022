require 'benchmark'

class Day
  include Benchmark

  def initialize
    raise 'unimplemented'
  end

  def part_a
    raise 'unimplemented'
  end

  def part_b
    raise 'unimplemented'
  end

  def self.run
    outputs = {}
    Benchmark.benchmark(CAPTION, 7, FORMAT, 'Total:') do |x|
      times = []
      self.descendants.reverse.each do |day|
        times << x.report("#{day.name}:") do
          1000.times do
            instance = day.new
            outputs[day.name] = {
              a: instance.part_a,
              b: instance.part_b
            }
          end
        end
      end

      [times.sum(Benchmark::Tms.new)]
    end

    outputs.each do |key, value|
      puts "#{key}; A: #{value[:a]}, B: #{value[:b]}"
    end
  end
end
