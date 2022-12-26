class Fifteen < Day
  class Sensor
    attr_reader :sensor, :beacon, :radius

    def initialize(sensor, beacon)
      @sensor = sensor
      @beacon = beacon
      @radius = Fifteen.distance(sensor, beacon) + 1
    end

    def contains_point(point)
      return false if point == @beacon

      Fifteen.distance(@sensor, point) < @radius
    end

    def lines
      [
        Fifteen::Line.new(1, [@sensor[0] + @radius, @sensor[1]]),
        Fifteen::Line.new(-1, [@sensor[0] + @radius, @sensor[1]]),
        Fifteen::Line.new(1, [@sensor[0] - @radius, @sensor[1]]),
        Fifteen::Line.new(-1, [@sensor[0] - @radius, @sensor[1]])
      ]
    end
  end

  class Line
    attr_accessor :gradient, :height

    def initialize(gradient, point)
      @gradient = gradient

      @height = point[1] - point[0] * gradient
    end

    def same_as?(other)
      @gradient == other.gradient && @height = other.height
    end

    def intersection(other)
      # m1x + c1 = m2x + c2
      # x(m1 - m2) = c2 - c1
      # x = (c2 - c1)/(m1 - m2)
      # y = m1x + c1
      x = (other.height - @height) / (@gradient - other.gradient)
      y = x * @gradient + @height

      [x, y]
    end
  end

  def self.distance(a, b)
    (a[0] - b[0]).abs + (a[1] - b[1]).abs
  end

  def initialize
    super

    @sensors = File.readlines('fifteen.txt', chomp: true).map do |line|
      a, b = line.split(':')
      sensor_point = a[12..].split(', y=').map(&:to_i)
      beacon_point = b[24..].split(', y=').map(&:to_i)

      Sensor.new(sensor_point, beacon_point)
    end
  end

  def part_a
    leftmost_range = @sensors.map { _1.sensor[0] - _1.radius }.min
    rightmost_range = @sensors.map { _1.sensor[0] + _1.radius }.max

    start = leftmost_range
    finish = rightmost_range
    beacon_count = @sensors.map(&:beacon).uniq.count { _1[1] == 2_000_000 }

    # consider something more like a binary search
    Kernel.loop do
      if sensor_present(start)
        start -= 1 while sensor_present(start)

        start += 1

        break
      end

      start += 3000
    end

    Kernel.loop do
      if sensor_present(finish)
        finish += 1 while sensor_present(finish)

        finish -= 1

        break
      end

      finish -= 3000
    end

    finish - start - beacon_count + 1
  end

  def sensor_present(x)
    @sensors.any? { _1.contains_point([x, 2000000]) }
  end

  def line_between(a, b)
    a.lines.find { |a_line| b.lines.any? { |b_line| a_line.height == b_line.height } }
  end

  def part_b
    a, b = @sensors.permutation(2).select { |(a, b)| (a.radius + b.radius - Fifteen.distance(a.sensor, b.sensor)).zero? }.map { |(a, b)| line_between(a, b) }.uniq(&:gradient)

    x, y = a.intersection(b)

    x * 4_000_000 + y
  end
end
