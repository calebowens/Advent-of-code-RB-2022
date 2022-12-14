class Ten < Day
  def initialize
    @instructions = File.readlines('ten.txt', chomp: true).map do |line|
      operation, oprand = line.split

      [operation, oprand.to_i]
    end
  end

  def part_a
    cycle_count = 1
    reg_x = 1
    output = 0

    @instructions.each do |(instruction, oprand)|
      cycle_count += 1

      output += reg_x * cycle_count if (cycle_count + 20) % 40 == 0

      next if instruction == 'noop'

      cycle_count += 1

      reg_x += oprand

      output += reg_x * cycle_count if (cycle_count + 20) % 40 == 0

      break if cycle_count > 241
    end

    output
  end

  def part_b
    cycle_count = 1
    reg_x = 1
    row = Array.new(40, ' ')
    output = "\n"

    @instructions.each do |(instruction, oprand)|
      cycle_count += 1

      if cycle_count % 40 == 0
        output += "#{row.join}\n"
        row = Array.new(40, ' ')
      end

      row[cycle_count % 40] = '#' if (reg_x..reg_x + 2).include?(cycle_count % 40)

      next if instruction == 'noop'

      cycle_count += 1

      reg_x += oprand

      if cycle_count % 40 == 0
        output += "#{row.join}\n"
        row = Array.new(40, ' ')
      end

      row[cycle_count % 40] = '#' if (reg_x..reg_x + 2).include?(cycle_count % 40)
    end

    output
  end
end
