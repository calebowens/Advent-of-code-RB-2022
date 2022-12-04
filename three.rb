class Three < Day
  LETTERS = [*('a'..'z'), *('A'..'Z')].freeze
  PRIORITIES = LETTERS.each.with_index.to_h { [_1, _2 + 1] }.freeze

  def initialize
    @lines = File.readlines('three.txt', chomp: true).map(&:chars)
  end

  def part_a
    @lines.sum do |line|
      size = line.size
      midpoint = size / 2

      union = line[0...midpoint] & line[midpoint..size]

      PRIORITIES[union.first]
    end
  end

  def part_b
    @lines.each_slice(3).sum { PRIORITIES[(_1[0] & _1[1] & _1[2]).first] }
  end
end
