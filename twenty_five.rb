# frozen_string_literal: true

# Day Twenty Five
class TwentyFive < Day
  def initialize
    super

    @numbers = File.readlines('twenty_five.txt', chomp: true).map do
      snafu_to_int(_1)
    end
  end

  def part_a
    int_to_snafu(@numbers.sum)
  end

  def part_b; end

  private

  def int_to_snafu(value)
    digits = []
    carry = false
    base = 5

    loop do
      n = (value % base)

      n += digits.pop if carry

      carry = n > 2

      if carry
        digits.push n - base
        digits.push 1
      else
        digits.push n
      end

      value /= base

      break if value.zero?
    end

    digits.reverse.sum('') { DIGIT_MAP_INVERSE[_1] }
  end

  def snafu_to_int(snafu_number)
    snafu_number.chars.reverse.each.with_index.sum { DIGIT_MAP[_1] * 5**_2 }
  end

  DIGIT_MAP =
    {
      '2' => 2,
      '1' => 1,
      '0' => 0,
      '-' => -1,
      '=' => -2
    }.freeze

  DIGIT_MAP_INVERSE = DIGIT_MAP.invert.freeze
end
