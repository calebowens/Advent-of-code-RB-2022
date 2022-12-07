class Six < Day
  def initialize
    @characters = File.open('six.txt').read.chomp.chars
  end

  def part_a
    solve(4)
  end

  def part_b
    solve(14)
  end

  def solve(size)
    @characters.each_cons(size).find_index { _1.uniq.size == size } + size
  end
end
