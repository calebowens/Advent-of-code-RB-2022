class TwentyFour < Day
  def initialize
    super

    @walls = []
    @blizards = {
      '^' => [],
      'v' => [],
      '<' => [],
      '>' => []
    }

    process_input

    set_blizard_area
  end

  def part_a
    @time = 0

    solve(Coordinate.new(0, 1), @exit)

    @time
  end

  def part_b
    solve(@exit, Coordinate.new(0, 1))
    solve(Coordinate.new(0, 1), @exit)

    @time
  end

  private

  def solve(start, finish)
    locations_to_search = [start]

    loop do
      @time += 1

      move_blizards

      locations_to_search = locations_to_search.flat_map { valid_moves(_1, start, finish) }.uniq

      break if locations_to_search.include? finish
    end
  end

  def valid_moves(coordinate, start, finish)
    [
      coordinate,
      coordinate.up,
      coordinate.down,
      coordinate.left,
      coordinate.right
    ].select { (in_bounds?(_1) && no_blizard_at?(_1)) || _1 == finish || _1 == start }
  end

  def no_blizard_at?(coordinate)
    !@blizard_map[coordinate]
  end

  def move_blizards
    @blizard_map = {}

    @blizards.each do |key, coordinates|
      direction = direction_map[key]
      coordinates.map! do |coordinate|
        coordinate.send("#{direction}!")

        map_to_bounds coordinate

        @blizard_map[coordinate] = true

        coordinate
      end
    end
  end

  def map_to_bounds(coordinate)
    if coordinate.x < @x_lower_bound
      coordinate.x = @x_upper_bound
    elsif coordinate.x > @x_upper_bound
      coordinate.x = @x_lower_bound
    elsif coordinate.y < @y_lower_bound
      coordinate.y = @y_upper_bound
    elsif coordinate.y > @y_upper_bound
      coordinate.y = @y_lower_bound
    end

    coordinate
  end

  def in_bounds?(coordinate)
    (@x_lower_bound..@x_upper_bound).include?(coordinate.x) &&
      (@y_lower_bound..@y_upper_bound).include?(coordinate.y)
  end

  def direction_map
    {
      '^' => 'up',
      'v' => 'down',
      '<' => 'left',
      '>' => 'right'
    }
  end

  def set_blizard_area
    @y_lower_bound = 1
    @x_lower_bound = 1
    @y_upper_bound = @walls.map(&:y).max - 1
    @x_upper_bound = @walls.map(&:x).max - 1
    @exit = Coordinate.new(@x_upper_bound, @y_upper_bound + 1)
    @blizard_map = {}
  end

  def process_input
    File.readlines('twenty_four.txt', chomp: true).each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        next if char == '.'

        if char == '#'
          @walls << Coordinate.new(x, y)
        else
          @blizards[char] << Coordinate.new(x, y)
        end
      end
    end
  end
end
