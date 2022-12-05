class Five < Day
  def initialize
    regexp = Regexp.compile(/(?:move | from | to )/)
    @crates = File.readlines('five_crates.txt', chomp: true).map { _1.split('') }
    @instructions = File.readlines('five_instructions.txt', chomp: true).map { _1.split(regexp)[1..3].map(&:to_i) }
  end

  def part_a
    crates = @crates.map(&:dup)

    @instructions.each do |(quantity, from, to)|
      quantity.times do
        crates[to - 1].push(crates[from - 1].pop)
      end
    end

    crates.sum('', &:last)
  end

  def part_b
    crates = @crates

    @instructions.each do |(quantity, from, to)|
      crates[to - 1].push(*crates[from - 1].pop(quantity))
    end

    crates.sum('', &:last)
  end
end
