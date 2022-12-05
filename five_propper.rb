class FivePropper < Day
  def initialize
    crates, instructions = File.open('five_propper.txt').read.split("\n\n")

    @crates = crates.split("\n").map { _1.split('') }.transpose.map(&:reverse).reject{ _1.first == ' ' }.map { _1.reject(&:blank?)[1..] }

    regexp = Regexp.compile(/(?:move | from | to )/)
    @instructions = instructions.split("\n").map { _1.chomp.split(regexp)[1..3].map(&:to_i) }
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
