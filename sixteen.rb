require 'matrix'

class Sixteen < Day
  class Graph
    attr_reader :nodes

    class Node
      attr_reader :edges, :value, :name

      def initialize(name, value)
        @edges = []
        @name = name
        @value = value
      end

      def add_edge(to, distance)
        @edges.push Edge.new(@name, to, distance)
      end
    end

    class Edge
      attr_reader :from, :to, :distance

      def initialize(from, to, distance)
        @from = from
        @to = to
        @distance = distance
      end
    end

    def initialize
      @nodes = {}
    end

    def add_node(name, value)
      @nodes[name] = Node.new(name, value)
    end

    def add_edge(from, to, distance)
      @nodes[from].add_edge(to, distance)
    end

    def distance_between(from, to)
      @nodes[from].edges.find { _1.to == to }&.distance || Float::INFINITY
    end

    def edges
      @nodes.values.flat_map(&:edges)
    end
  end

  def initialize
    input_graph = Graph.new

    File.readlines('sixteen.txt', chomp: true).each do |line|
      front, back = line.split(';')

      name = line[6..7]

      flow_rate = front.split('=').last.to_i
      connections = back.split(/valves |valve /).last.split(', ')

      input_graph.add_node(name, flow_rate)

      connections.each do |connection|
        input_graph.add_edge(name, connection, 1) # all are distance one to start with
      end
    end

    v = input_graph.nodes.size

    @graph = input_graph
    @node_map = input_graph.nodes.keys.each.with_index.to_h
    @node_map_inverse = @node_map.invert
    @distance_matrix = Matrix.build(v, v) { |i, j| input_graph.distance_between(@node_map_inverse[i], @node_map_inverse[j]) }

    v.times do |i|
      @distance_matrix[i, i] = 0
    end

    v.times do |k|
      v.times do |i|
        v.times do |j|
          if @distance_matrix[i, j] > @distance_matrix[i, k] + @distance_matrix[k, j]
            @distance_matrix[i, j] = @distance_matrix[i, k] + @distance_matrix[k, j]
          end
        end
      end
    end

    v.times do |i|
      v.times do |j|
        @distance_matrix[i, j] += 1
      end
    end

    @important_nodes_map = @graph.nodes.values.reject { _1.value.zero? }.map { [_1.name, @node_map[_1.name]] }.to_h
  end

  def part_a(
    current_node = 'AA',
    unvisited = @important_nodes_map,
    time = 0,
    score = 0
  )
    return score if time > 30

    score += (30 - time) * @graph.nodes[current_node].value

    unvisited = unvisited.except(current_node)

    return score if unvisited.empty?

    unvisited.keys.map do |key|
      part_a(key, unvisited, time + @distance_matrix[@node_map[current_node], @node_map[key]], score)
    end.max
  end

  def part_b(
    current_person_node = 'AA',
    current_elephant_node = 'AA',
    unvisited = @important_nodes_map,
    person_time = 0,
    elephant_time = 0,
    score = 0
  )
    return score if person_time > 26 || elephant_time > 26

    score += (26 - person_time) * @graph.nodes[current_person_node].value
    score += (26 - elephant_time) * @graph.nodes[current_elephant_node].value

    unvisited = unvisited.except(current_person_node)
    unvisited = unvisited.except(current_elephant_node)

    return score if unvisited.empty?

    unvisited.keys.permutation(2).map do |(person, elephant)|
      person_time += @distance_matrix[@node_map[current_person_node], @node_map[person]]
      elephant_time += @distance_matrix[@node_map[current_elephant_node], @node_map[elephant]]

      part_b(person, elephant, unvisited, person_time, elephant_time, score)
    end.max
  end

  def inspect
    puts important_nodes_map.keys

    puts '['

    important_nodes_map.each_value do |i|
      print '['

      important_nodes_map.each_value do |j|
        print "#{@distance_matrix[i, j]}, "
      end

      print "]\n"
    end

    puts ']'
  end
end
