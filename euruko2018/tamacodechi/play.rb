# Fewer than 2 neighbors will die.
# Exactly 3 neighbors will live.
# Greater than 3 neighbors will die.

class Game
  def initialize(size)
    @matrix = Array.new(size) { Array.new(size) { Cell.new } }
    @generations = [@matrix.dup]
  end

  def display
    @matrix.each do |row|
      row.each do |cell|
        print cell.alive ? '🦑' : '🍣'
      end

      puts
    end
  end

  def next_day
    new_matrix = Array.new(size) { Array.new(size) { Cell.new } }

    @matrix.each do |row|
      row.each do |cell|
        # this works!
      end
    end

    @matrix = new_matrix
    generations << new_matrix
  end

  # percentage must be divisible by 10 or this breaks
  def make_sushi(percentage = 70)
    @matrix.each do |row|
      row.each do |cell|
        cell.kill! if rand(1..10) <= percentage / 10
      end
    end
  end
end

class Cell
  attr_reader :alive

  def initialize
    @alive = true
  end

  def kill!
    @alive = false
  end
end

game = Game.new(10)
game.make_sushi
game.display
