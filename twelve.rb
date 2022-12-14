class Twelve < Day
  class Node
    attr_accessor :edges
    attr_reader :position

    def initialize(x, y)
      @position = [x, y]
      @edges = []
    end

    def id
      "#{@position[0]} - #{@position[1]}"
    end

    def inspect
      "<Node id=\"#{id}\", @edges=#{@edges.map(&:id).inspect}>"
    end
  end

  # This is a digraph
  class Graph
    attr_reader :nodes

    def initialize(char_map)
      @char_map = char_map
      @nodes = Array.new(@char_map.size).map { [] }
      @width_range = 0...@char_map.size
      @height_range = 0...@char_map.first.size
    end

    def node(x, y)
      return nil unless @width_range.include?(x) && @height_range.include?(y)
      return @nodes[x][y] unless @nodes[x][y].nil?

      node_height = height(@char_map[x][y])

      # Its important to register the node here before accessing it below
      @nodes[x][y] = Node.new(x, y)

      @nodes[x][y].edges = [
        accesable_node_or_nil(x - 1, y, node_height),
        accesable_node_or_nil(x + 1, y, node_height),
        accesable_node_or_nil(x, y - 1, node_height),
        accesable_node_or_nil(x, y + 1, node_height)
      ].reject(&:nil?)

      @nodes[x][y]
    end

    def accesable_node_or_nil(x, y, current_height)
      return nil unless @width_range.include?(x) && @height_range.include?(y)
      return nil if height(@char_map[x][y]) > 1 + current_height

      node(x, y)
    end

    def height(letter)
      return 0 if letter == 'S'
      return 25 if letter == 'E'

      letter.ord - 97
    end
  end

  def initialize
    super

    char_map = File.readlines('twelve.txt', chomp: true).map(&:chars)

    @graph = Graph.new(char_map)
    @graph.node(0, 0)
  end

  def part_a
    nodes = {}
    unvisited_nodes = {}

    @graph.nodes.flatten.reject(&:nil?).each do |n|
      nodes[n.id] = {
        distance: Float::INFINITY,
        preivous: nil,
        node: n
      }
      unvisited_nodes[n.id] = true
    end

    nodes['20 - 0'][:distance] = 0

    until unvisited_nodes.values.size.zero?
      minimum_node = nodes.values.sort_by { _1[:distance] }.select { unvisited_nodes.key?(_1[:node].id) }.first
      unvisited_nodes.delete(minimum_node[:node].id)

      minimum_node[:node].edges.each do |node|
        next unless unvisited_nodes.key?(node.id)

        new_distance = minimum_node[:distance] + 1

        if new_distance < nodes[node.id][:distance]
          nodes[node.id][:distance] = new_distance
          nodes[node.id][:previous] = minimum_node
        end
      end
    end

    nodes['20 - 158'][:distance]
  end

  def part_b; end
end
