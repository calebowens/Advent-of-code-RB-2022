# TwentyTwo
class TwentyTwo < Day
  # Coordinate decorator
  class CoordinateDecorator < SimpleDelegator
    def x
      self[0]
    end

    def x=(value)
      self[0] = value
    end

    def y
      self[1]
    end

    def y=(value)
      self[1] = value
    end

    def left
      CoordinateDecorator.new([x - 1, y])
    end

    def left!
      self.x -= 1

      self
    end

    def right
      CoordinateDecorator.new([x + 1, y])
    end

    def right!
      self.x += 1

      self
    end

    def up
      CoordinateDecorator.new([x, y - 1])
    end

    def up!
      self.y -= 1

      self
    end

    def down
      CoordinateDecorator.new([x, y + 1])
    end

    def down!
      self.y += 1

      self
    end

    def one_indexed
      CoordinateDecorator.new([x + 1, y + 1])
    end
  end

  # MonkeyBoard
  class MonkeyBoard
    attr_reader :trace, :position, :facing

    def initialize
      @objects = {}
      @facing = :right
      @largest_x = 0
      @largest_y = 0
      @trace = {}
    end

    def initialize_position
      @position = CoordinateDecorator.new([0, 0])

      move_to_next_right
    end

    def add_object(position, value)
      @objects[position] = value

      @largest_x = [@largest_x, position.x].max
      @largest_y = [@largest_y, position.y].max
    end

    def poisition_or_new_position(new_position)
      @objects[new_position] == :wall ? :hit_wall : @position = new_position
    end

    def move_distance(distance)
      distance.times do
        out = case @facing
              when :left
                move_to_next_left
              when :right
                move_to_next_right
              when :up
                move_to_next_up
              when :down
                move_to_next_down
              end

        break if out == :hit_wall
      end
    end

    def rotate(direction)
      @facing = if direction == 'L'
                  {
                    left: :down,
                    down: :right,
                    right: :up,
                    up: :left
                  }[@facing]
                else
                  {
                    left: :up,
                    up: :right,
                    right: :down,
                    down: :left
                  }[@facing]
                end
    end

    def move_to_next_right
      case @objects[@position.right]
      when :space
        @position.right!

        @trace[@position] = '>'
      when :wall
        :hit_wall
      else
        position = CoordinateDecorator.new([0, @position.y])

        position.x += 1 until @objects.key? position

        poisition_or_new_position position
      end
    end

    def move_to_next_left
      case @objects[@position.left]
      when :space
        @position.left!

        @trace[@position] = '<'
      when :wall
        :hit_wall
      else
        position = CoordinateDecorator.new([@largest_x, @position.y])

        position.x -= 1 until @objects.key? position

        poisition_or_new_position position
      end
    end

    def move_to_next_up
      case @objects[@position.up]
      when :space
        @position.up!

        @trace[@position] = '^'
      when :wall
        :hit_wall
      else
        position = CoordinateDecorator.new([@position.x, @largest_y])

        position.y -= 1 until @objects.key? position

        poisition_or_new_position position
      end
    end

    def move_to_next_down
      case @objects[@position.down]
      when :space
        @position.down!

        @trace[@position] = 'v'
      when :wall
        :hit_wall
      else
        position = CoordinateDecorator.new([@position.x, 0])

        position.y += 1 until @objects.key? position

        poisition_or_new_position position
      end
    end
  end

  def initialize
    super

    @monkey_board = MonkeyBoard.new

    board, instructions = File.open('twentytwo.txt', chomp: true).read.split("\n\n")

    board.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        next if char == ' '

        @monkey_board.add_object(CoordinateDecorator.new([x, y]), char == '.' ? :space : :wall)
      end
    end

    @monkey_board.initialize_position

    instructions.split(/(L|R)/).each do |char|
      if %w[L R].include? char
        @monkey_board.rotate(char)
      else
        @monkey_board.move_distance(char.to_i)
      end
    end
  end

  def part_a
    final_point = @monkey_board.position.one_indexed

    final_facing = case @monkey_board.facing
                   when :left
                     2
                   when :right
                     0
                   when :up
                     3
                   when :down
                     1
                   end

    final_point.y * 1000 + final_point.x * 4 + final_facing
  end

  def part_b; end
end
