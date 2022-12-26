# A wrapper for 2d coordinates
class Coordinate
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def left
    Coordinate.new(@x - 1, @y)
  end

  def left!
    @x -= 1

    self
  end

  def right
    Coordinate.new(@x + 1, @y)
  end

  def right!
    @x += 1

    self
  end

  def up
    Coordinate.new(@x, @y - 1)
  end

  def up!
    @y -= 1

    self
  end

  def down
    Coordinate.new(@x, @y + 1)
  end

  def down!
    @y += 1

    self
  end

  alias west left
  alias west! left!
  alias east right
  alias east! right!
  alias north up
  alias north! up!
  alias south down
  alias south! down!

  def one_indexed
    Coordinate.new(@x + 1, @y + 1)
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def eql?(other)
    @x == other.x && @y == other.y
  end

  def hash
    @x * 100_000 + @y
  end
end
