class Four < Day
  def initialize
    @lines = File.readlines('four.txt', chomp: true)
  end

  def part_a
    @lines.sum do
      points = _1.split(',').map { |a| a.split('-').map(&:to_i) }

      (points[0][0] <= points[1][0] && points[0][1] >= points[1][1] ||
        points[0][0] >= points[1][0] && points[0][1] <= points[1][1]) ? 1 : 0
    end
  end

  def part_b
    @lines.sum do
      points = _1.split(',').map { |a| a.split('-').map(&:to_i) }

      (
        points[0][0] <= points[1][0] && points[0][1] >= points[1][0] ||
        points[0][0] <= points[1][1] && points[0][1] >= points[1][1] ||
        points[1][0] <= points[0][0] && points[1][1] >= points[0][0] ||
        points[1][0] <= points[0][1] && points[1][1] >= points[0][1]
      ) ? 1 : 0
    end
  end
end
