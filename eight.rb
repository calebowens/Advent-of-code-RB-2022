class Eight < Day
  def initialize
    @rows = File.readlines('eight.txt', chomp: true).map { _1.chars.map(&:to_i) }
    @transpose = @rows.transpose
    @indexed = @rows.map { _1.each.with_index.to_a }.each.with_index.to_a
    @indexed_transpose = @transpose.map { _1.each.with_index.to_a }.each.with_index.to_a
  end

  def part_a
    left_visable_trees = visable_trees(@indexed)
    right_visable_trees = visable_trees(@indexed.map { |(row, index)| [row.reverse, index] })
    top_visable_trees = visable_trees(@indexed_transpose, true)
    bottom_visable_trees = visable_trees(@indexed_transpose.map { |(row, index)| [row.reverse, index] }, true)

    (left_visable_trees + right_visable_trees + top_visable_trees + bottom_visable_trees).uniq.size
  end

  def visable_trees(rows, transpose = false)
    rows.flat_map do |(row, x)|
      row.reduce([[], -1]) { |(visable_trees, previous_highest), (tree_height, y)|
        if tree_height > previous_highest
          [[*visable_trees, transpose ? [y, x] : [x, y]], tree_height]
        else
          [visable_trees, previous_highest]
        end
      }.first
    end
  end

  def part_b
    @indexed.flat_map { |(row, x)|
      row.map do |(tree_height, y)|
        side_score(tree_height, @rows[x][0...y].reverse) *
          side_score(tree_height, @rows[x][(y + 1)..]) *
          side_score(tree_height, @transpose[y][0...x].reverse) *
          side_score(tree_height, @transpose[y][(x + 1)..])
      end
    }.max
  end

  def side_score(tree_height, arr)
    arr.reduce(0) { |count, other_height|
      if other_height >= tree_height
        break count + 1
      else
        count + 1
      end
    }
  end
end
