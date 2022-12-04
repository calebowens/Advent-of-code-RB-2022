class One < Day
  def initialize
    file = File.open('one.txt').read

    @sums = file # 1\n2\n\n3\n4
    .split("\n\n") # 1\n2, 3\n4
    .map { _1.split.sum(&:to_i) }
    .max(3)
  end

  def part_a
    @sums.max
  end

  def part_b
    @sums.sum
  end
end
