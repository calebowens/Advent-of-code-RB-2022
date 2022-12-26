class Graph
  class Node
    def initialize(value)
      @edges = []
      @value = value
    end

    def add_edge(to, distance)
      @edges.push Edge.new(to, distnace)
    end
  end

  class Edge
    attr_reader :to, :distance

    def initialize(to, distance)
      @to = to
      @distance = distance
    end
  end

  def initialize
    @nodes = {}
    @edges = []
  end

  def add_node(name, value)
    @nodes[name] = Node.new
  end

  def add_edge(from, to, distance)
    @nodes[from].add_edge(to, distnace)
  end

  def distance_between(from, to)
    @nodes[from].find { _1.to == to }&.distance || 0
  end
end
