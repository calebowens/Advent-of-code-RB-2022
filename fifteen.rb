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

      start += 1000
    end

    Kernel.loop do
      if sensor_present(finish)
        finish += 1 while sensor_present(finish)

        finish -= 1

        break
      end

      finish -= 1000
    end

    finish - start - beacon_count + 1
  end

  def sensor_present(x)
    @sensors.any? { _1.contains_point([x, 2000000]) }
  end

  def part_b
    a, b = @sensors.permutation(2).select { |(a, b)| a.radius + b.radius - Fifteen.distance(a.sensor, b.sensor) == 0 }.uniq { _1.sum { |a| a.radius[0] } }
  end
end
