# frozen_string_literal: true

# TwentyThree
class TwentyThree < Day
  # Handy class to loop through the options
  class RingDecorator < SimpleDelegator
    def next_iteration
      out = dup

      push shift

      out
    end
  end

  def initialize
    super

    @elves = File.readlines('twenty_three.txt', chomp: true).each.with_index.flat_map do |line, y|
      line.chars.each.with_index.map do |char, x|
        [CoordinateDecorator.new([x, y]), :elf] if char == '#'
      end.compact
    end.to_h
  end

  def part_a
    @directions = RingDecorator.new(%w[north south west east])

    still_moving = true

    @turns = 0

    while still_moving
      still_moving = do_move

      @turns += 1

      break if @turns >= 10
    end

    x_min = @elves.keys.map(&:x).min
    x_max = @elves.keys.map(&:x).max
    y_min = @elves.keys.map(&:y).min
    y_max = @elves.keys.map(&:y).max

    (x_max - x_min + 1) * (y_max - y_min + 1) - @elves.size
  end

  def part_b
    still_moving = true

    while still_moving
      still_moving = do_move

      @turns += 1
    end

    @turns
  end

  private

  def do_move
    props = propositions

    @directions.next_iteration

    return false if props.empty?

    props.each do |key, value|
      @elves.delete key
      @elves[value] = :elf
    end

    true
  end

  def propositions
    propositions = {}

    @elves.each_key do |coordinate|
      next if none_surrounding? coordinate, @elves

      move coordinate, propositions
    end

    remove_duplicates(propositions)
  end

  def move(coordinate, propositions)
    @directions.each do |direction|
      next unless send("none_#{direction}?", coordinate, @elves)

      propositions[coordinate] = coordinate.send(direction)

      break
    end
  end

  def remove_duplicates(hash)
    value_counts = {}

    hash.each do |_, value|
      if value_counts[value].present?
        value_counts[value] += 1
      else
        value_counts[value] = 1
      end
    end

    value_counts = value_counts.each.reject { _1[1] > 1 }.to_h

    hash.select { value_counts.key?(hash[_1]) }
  end

  def none_north?(coordinate, map)
    [
      coordinate.north.west,
      coordinate.north,
      coordinate.north.east
    ].none? { map.key? _1 }
  end

  def none_south?(coordinate, map)
    [
      coordinate.south.west,
      coordinate.south,
      coordinate.south.east
    ].none? { map.key? _1 }
  end

  def none_east?(coordinate, map)
    [
      coordinate.east.north,
      coordinate.east,
      coordinate.east.south
    ].none? { map.key? _1 }
  end

  def none_west?(coordinate, map)
    [
      coordinate.west.north,
      coordinate.west,
      coordinate.west.south
    ].none? { map.key? _1 }
  end

  def none_surrounding?(coordinate, map)
    [
      coordinate.north.west,
      coordinate.north,
      coordinate.north.east,
      coordinate.west,
      coordinate.east,
      coordinate.south.west,
      coordinate.south,
      coordinate.south.east
    ].none? { map.key? _1 }
  end
end
