
class Cell
  attr_accessor :alive

  def initialize(alive = false)
    @alive = alive
  end
end

class Board
  def initialize
    @rows = 10
    @cols = 10
    @cells = Array.new(@rows) { Array.new(@cols) {  Cell.new } }
  end

  def seed
    seed_map = <<~EOF
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
      X__X__XX_X
    EOF
    @cells = seed_map.split("\n").map do |r|
      r.split("").map do |c|
        Cell.new(c == 'X')
      end
    end
  end

  # Fewer than 2 neighbors will die.
  # 2 neighbors will live.
  # Exactly 3 neighbors will live, or breed if dead.
  # Greater than 3 neighbors will die.

  def iterate
    @cells = @cells.map.with_index do |row, row_index|
      row.map.with_index do |cell, col_index|
        case count_neighbors(row_index, col_index)
        when 0..1
          Cell.new(false)
        when 2
          cell
        when 3
          Cell.new(true)
        when 4..8
          Cell.new(false)
        end
      end
    end
  end

  def to_s
    @cells.map do |row|
      row.map do |cell|
        cell.alive ? 'X' : '_' 
      end.join + "\n"
    end.join
  end

  private

  def count_neighbors(row_index, col_index)
    neighbors_sum = 0
    [-1, 0, +1].each do |row_delta|
      target_row = row_index + row_delta
      next if target_row < 0 || target_row > @rows - 1

      [-1, 0, +1].each do |col_delta|
        next if row_delta.zero? && col_delta.zero?
        
        target_col = col_index + col_delta
        next if target_col < 0 || target_col > @cols - 1

        begin
          neighbors_sum += 1 if @cells[target_row][target_col].alive
        rescue
          require 'pry'
          binding.pry
        end
      end
    end

    neighbors_sum
  end
end

board = Board.new
board.seed
puts board

loop do
  sleep 0.5
  system "clear"
  board.iterate
  puts board
end
