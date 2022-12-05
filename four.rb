class Four < Day
  def initialize
    @points = File.readlines('four.txt', chomp: true).map do
      a, b = _1.split(',')

      c, d = a.split('-')
      e, f = b.split('-')
      [c.to_i, d.to_i, e.to_i, f.to_i]
    end
  end

  def part_a
    @points.select {
      _1[0] <= _1[2] && _1[1] >= _1[3] ||
      _1[0] >= _1[2] && _1[1] <= _1[3]
    }.size
  end

  def part_b
    @points.select {
      _1[0] <= _1[2] && _1[1] >= _1[2] ||
      _1[0] <= _1[3] && _1[1] >= _1[3] ||
      _1[2] <= _1[0] && _1[3] >= _1[0] ||
      _1[2] <= _1[1] && _1[3] >= _1[1]
    }.size
  end
end
