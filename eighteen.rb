require 'set'

class Eighteen < Day
  def initialize
    super

    @cubes = File.readlines('eighteen.txt', chomp: true).map { _1.split(',').map(&:to_i) }.to_set
  end

  def part_a
    @cubes.sum do |(x, y, z)|
      [
        @cubes.include?([x + 1, y, z]),
        @cubes.include?([x - 1, y, z]),
        @cubes.include?([x, y + 1, z]),
        @cubes.include?([x, y - 1, z]),
        @cubes.include?([x, y, z + 1]),
        @cubes.include?([x, y, z - 1]),
      ].count { !_1 }
    end
  end

  def part_b
    surface_area = 0

    searched = Set.new

    to_search = [[0, 0, 0]]

    until to_search.size.zero?
      current = to_search.pop

      searched << current

      x, y, z = current

      surface_area += [
        @cubes.include?([x + 1, y, z]),
        @cubes.include?([x - 1, y, z]),
        @cubes.include?([x, y + 1, z]),
        @cubes.include?([x, y - 1, z]),
        @cubes.include?([x, y, z + 1]),
        @cubes.include?([x, y, z - 1]),
      ].count { _1 }

      eles = next_elements(current, searched)

      searched += eles
      to_search += eles
    end

    surface_area
  end

  def next_elements((x, y, z), searched)
    [
      [x + 1, y, z],
      [x - 1, y, z],
      [x, y + 1, z],
      [x, y - 1, z],
      [x, y, z + 1],
      [x, y, z - 1],
    ].select { in_bounds?(_1) && !searched.include?(_1) && !@cubes.include?(_1) }
  end

  def in_bounds?((x, y, z))
    x >= -1 && y >= -1 && z >= -1 && x <= 22 && y <= 22 && z <= 22
  end
end
