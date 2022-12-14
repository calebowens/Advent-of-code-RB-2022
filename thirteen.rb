class Thirteen < Day
  def initialize
    super

    @arrays = File.open('thirteen.txt').read.split("\n\n").map do |array_pair|
      array_pair.split("\n").map { eval(_1) }
    end
  end

  def pad(arr, size)
    to_fill = size - arr.size

    arr + Array.new([0, to_fill].max, nil)
  end

  def compare(a, b)
    return -1 if a.nil?
    return 1 if b.nil?

    case [a.class.name, b.class.name]
    when %w[Integer Integer]
      a <=> b
    when %w[Integer Array]
      compare([a], b)
    when %w[Array Integer]
      compare(a, [b])
    when %w[Array Array]
      pad(a, b.size).zip(b).each do |(c, d)|
        out = compare(c, d)

        return out unless out.zero?
      end

      0
    end
  end

  def part_a
    output = 0

    @arrays.each_with_index do |(a, b), index|
      output += index + 1 if compare(a, b) == -1
    end

    output
  end

  def part_b
    sort = (@arrays.flatten(1) + [[2], [6]]).sort { compare(_1, _2) }

    a = sort.find_index { _1 == [2] } + 1
    b = sort.find_index { _1 == [6] } + 1

    a * b
  end
end
