class SixOptimised < Day
  def initialize
    @characters = File.open('six.txt').read.chomp.chars
  end

  def part_a
    solve(4)
  end

  def part_b
    solve(14)
  end

  def solve(n)
    base = 0

    unsolved = true
    while unsolved
      unsolved = false

      letter_hash = {}

      n.times do |m|
        if letter_hash[@characters[base + m]]
          base += 1

          unsolved = true
          break
        end

        letter_hash[@characters[base + m]] = true
      end
    end

    base + n
  end
end
