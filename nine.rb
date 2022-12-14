class Nine < Day
  def initialize
    @instructions = File.readlines('nine.txt', chomp: true).map do
      a, b = _1.split

      [a, b.to_i]
    end
  end

  def part_a
    visited_locations = []
    tail = [0, 0]
    head = [0, 0]

    @instructions.each do |(direction, step)|
      step.times do
        new_head = updated_head_position(direction, head)

        if distance(new_head, tail) <= 1
          head = new_head
        else
          visited_locations.push(tail)
          tail = head
          head = new_head
        end
      end
    end

    visited_locations.uniq.size
  end

  def updated_head_position(direction, (x, y))
    case direction
    when 'U'
      [x, y + 1]
    when 'D'
      [x, y - 1]
    when 'L'
      [x - 1, y]
    when 'R'
      [x + 1, y]
    end
  end

  # Chebyshev distance
  def distance((x1, y1), (x2, y2))
    [(x1 - x2).abs, (y1 - y2).abs].max
  end

  def part_b
    visited_locations = []

    snake = [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ]

    @instructions.each do |(direction, step)|
      step.times do
        intermediary_position = snake[0]
        snake[0] = updated_head_position(direction, snake[0])

        snake[1..].each_with_index do |segment, index|
          if distance(snake[index], segment) > 1
            snake[index + 1] = intermediary_position
          end

          intermediary_position = segment
        end

        visited_locations.push(snake.last)
      end
    end

    visited_locations.uniq.size
  end
end
