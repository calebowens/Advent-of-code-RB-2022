class Two < Day
  ROCK_BONUS = 1
  PAPER_BONUS = 2
  SCISORS_BONUS = 3
  WIN = 6
  DRAW = 3

  A_SCORE_MAP = {
    'A X' => ROCK_BONUS + DRAW,
    'A Y' => PAPER_BONUS + WIN,
    'A Z' => SCISORS_BONUS,
    'B X' => ROCK_BONUS,
    'B Y' => PAPER_BONUS + DRAW,
    'B Z' => SCISORS_BONUS + WIN,
    'C X' => ROCK_BONUS + WIN,
    'C Y' => PAPER_BONUS,
    'C Z' => SCISORS_BONUS + DRAW,
  }.freeze

  B_SCORE_MAP = {
    'A X' => SCISORS_BONUS,
    'A Y' => ROCK_BONUS + DRAW,
    'A Z' => PAPER_BONUS + WIN,
    'B X' => ROCK_BONUS,
    'B Y' => PAPER_BONUS + DRAW,
    'B Z' => SCISORS_BONUS + WIN,
    'C X' => PAPER_BONUS,
    'C Y' => SCISORS_BONUS + DRAW,
    'C Z' => ROCK_BONUS + WIN,
  }.freeze

  def initialize
    @lines = File.readlines('two.txt', chomp: true)
  end

  def part_a
    @lines.sum { A_SCORE_MAP[_1] }
  end

  def part_b
    @lines.sum { B_SCORE_MAP[_1] }
  end
end
