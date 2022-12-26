# frozen_string_literal: true

# Day 21
class TwentyOne < Day
  # Equation
  class Equation
    attr_reader :left, :right, :operation

    def initialize(left:, right:, operation:)
      @left = left
      @right = right
      @operation = operation
    end
  end

  # Value
  class Value
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end

  # Tree of expression
  class ExpressionTree
    attr_reader :operation, :left, :right

    def initialize(expression, values)
      @operation = expression.operation

      @left = if values[expression.left].is_a? Equation
                ExpressionTree.new(values[expression.left], values)
              else
                values[expression.left].value
              end

      @right = if values[expression.right].is_a? Equation
                 ExpressionTree.new(values[expression.right], values)
               else
                 values[expression.right].value
               end
    end
  end

  def initialize
    super

    @tree = ExpressionTree.new(values['root'], values)
  end

  def values
    @values ||= File.readlines('twentyone.txt', chomp: true).map do |line|
      name, part = line.split(':')

      parts = part.split(%r{\+|-|\*|/})

      [
        name,
        if parts.size == 1
          Value.new(parts.first.to_i)
        else
          Equation.new(left: parts.first.strip, right: parts.second.strip, operation: part[6])
        end
      ]
    end.to_h
  end

  def part_a
    solve(@tree)
  end

  def solve(node)
    return node if node.is_a? Numeric

    operation = node.operation.to_sym.to_proc

    operation.call(solve(node.left), solve(node.right))
  end

  def part_b; end
end
