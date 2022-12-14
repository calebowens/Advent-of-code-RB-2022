# frozen_string_literal: true

class Fourteen < Day
  class TwoDimensionalDecorator < SimpleDelegator
    def [](key)
      return super if super

      self[key] = []

      self[key]
    end

    def depth
      reject(&:nil?).map(&:size).max
    end
  end

  class SandGrain
    attr_reader :position

    def initialize(scene)
      @scene = scene
      @depth = @scene.depth
      # Sand grains all start at 500, 0
      @position = [500, 0]
    end

    def fall
      while space_below?
        move_down

        return :void if y > @depth
      end

      @scene[x][y] = 'o'

      :landed
    end

    def move_down
      if @scene[x][y + 1].nil?
        @position[1] += 1
      elsif @scene[x - 1][y + 1].nil?
        @position[0] -= 1
        @position[1] += 1
      elsif @scene[x + 1][y + 1].nil?
        @position[0] += 1
        @position[1] += 1
      end
    end

    def x
      @position[0]
    end

    def y
      @position[1]
    end

    def space_below?
      @scene[x][y + 1].nil? ||
        @scene[x + 1][y + 1].nil? ||
        @scene[x - 1][y + 1].nil?
    end
  end

  def initialize
    super

    @line_points = File.readlines('fourteen.txt', chomp: true).flat_map {
      _1.split(' -> ').map { |a| a.split(',').map(&:to_i) }.each_cons(2).to_a
    }.map { line_points(_1[0], _1[1]) }.flatten(1)

    @scene = build_scene
  end

  def line_points(start, finish)
    if start[0] == finish[0]
      if start[1] > finish[1]
        (finish[1]..start[1]).map { [start[0], _1] }
      else
        (start[1]..finish[1]).map { [start[0], _1] }
      end
    else
      if start[0] > finish[0]
        (finish[0]..start[0]).map { [_1, start[1]] }
      else
        (start[0]..finish[0]).map { [_1, start[1]] }
      end
    end
  end

  def build_scene
    scene = TwoDimensionalDecorator.new([])

    @line_points.each do |(x, y)|
      scene[x][y] = '#'
    end

    scene
  end

  def part_a
    grain_count = 0

    Kernel.loop do
      grain_count += 1
      grain = SandGrain.new(@scene)

      out = grain.fall

      break if out == :void
    end

    @part_a ||= grain_count - 1
  end

  def part_b
    floor_depth = @scene.depth + 1

    ((500 - floor_depth * 2)..(500 + floor_depth * 2)).each do |x|
      @scene[x][floor_depth] = '~'
    end

    grain_count = 0

    Kernel.loop do
      grain_count += 1
      grain = SandGrain.new(@scene)

      grain.fall

      break if grain.position == [500, 0]
    end

    @part_a + grain_count
  end
end
