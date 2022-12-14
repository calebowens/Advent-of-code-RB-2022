class Eleven < Day
  class Monkey
    attr_reader :inspection_count, :test_devisor, :items

    def initialize(starting_items:, operation:, test_devisor:, true_monkey:, false_monkey:)
      instance_eval(
        """
def operation(old)
  #{operation}
end
        """
      )

      @items = starting_items
      @test_devisor = test_devisor
      @true_monkey = true_monkey
      @false_monkey = false_monkey
      @inspection_count = 0
    end

    def monkeys=(monkeys)
      @monkeys = monkeys
    end

    def number=(number)
      @number = number
    end

    def common_devisor=(devisor)
      @common_devisor = devisor
    end

    def send_item(recieving_item)
      @items.push(recieving_item)
    end

    def take_turn
      @items.each do |item|
        @inspection_count += 1
        new_worry_level = operation(item) / 3

        if new_worry_level % @test_devisor == 0
          @monkeys[@true_monkey].send_item(new_worry_level)
        else
          @monkeys[@false_monkey].send_item(new_worry_level)
        end
      end
      @items = []
    end

    def take_worrysome_turn
      @items.each do |item|
        @inspection_count += 1
        new_worry_level = operation(item)

        new_worry_level %= @common_devisor

        if new_worry_level % @test_devisor == 0
          @monkeys[@true_monkey].send_item(new_worry_level)
        else
          @monkeys[@false_monkey].send_item(new_worry_level)
        end
      end
      @items = []
    end
  end

  def initialize
    @file = File.open('eleven.txt').read.split("\n\n")
  end

  def part_a
    monkeys = @file.map do |raw_monkey|
      lines = raw_monkey.split("\n").map(&:chomp)
      starting_items = lines[1].split(':').second.split(',').map(&:to_i)
      operation = lines[2].split('=').second
      test_devisor = lines[3].split.last.to_i
      true_monkey = lines[4].split.last.to_i
      false_monkey = lines[5].split.last.to_i

      Monkey.new(
        starting_items: starting_items,
        operation: operation,
        test_devisor: test_devisor,
        true_monkey: true_monkey,
        false_monkey: false_monkey
      )
    end

    monkeys.each_with_index do |monkey, index|
      monkey.monkeys = monkeys
      monkey.number = index
    end

    20.times do
      monkeys.each(&:take_turn)
    end

    a, b = monkeys.map(&:inspection_count).max(2)
    a * b
  end

  def part_b
    monkeys = @file.map do |raw_monkey|
      lines = raw_monkey.split("\n").map(&:chomp)
      starting_items = lines[1].split(':').second.split(',').map(&:to_i)
      operation = lines[2].split('=').second
      test_devisor = lines[3].split.last.to_i
      true_monkey = lines[4].split.last.to_i
      false_monkey = lines[5].split.last.to_i

      Monkey.new(
        starting_items: starting_items,
        operation: operation,
        test_devisor: test_devisor,
        true_monkey: true_monkey,
        false_monkey: false_monkey
      )
    end

    monkeys.each_with_index do |monkey, index|
      monkey.monkeys = monkeys
      monkey.number = index
    end

    common_devisor = monkeys.reduce(1) { _1 * _2.test_devisor }

    monkeys.each do |monkey|
      monkey.common_devisor = common_devisor
    end

    10000.times do
      monkeys.each(&:take_worrysome_turn)
    end

    a, b = monkeys.map(&:inspection_count).max(2)
    a * b
  end
end
