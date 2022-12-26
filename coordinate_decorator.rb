# A wrapper for 2d coordinates
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

  alias west left
  alias west! left!
  alias east right
  alias east! right!
  alias north up
  alias north! up!
  alias south down
  alias south! down!

  def one_indexed
    CoordinateDecorator.new([x + 1, y + 1])
  end
end
