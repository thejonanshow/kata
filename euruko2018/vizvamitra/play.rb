# Fewer than 2 neighbours will die.
# Exactly 3 neighbours will live.
# Greater than 3 neighbours will die.

class Game
  def initialize(stringify_board: StringifyBoard.new,
                 judge: Judge.new)
    @stringify_board = stringify_board
    @judge = judge
  end

  def call(width:, height:, seed:)
    board = Board.new(width, height, seed)
    loop do
      board = step(board)
      print(board)
      sleep(0.5)
    end
  end

  private

  attr_reader :stringify_board, :judge

  def step(board)
    new_state = board.state.dup
    (0...board.height).each do |row_index|
      (0...board.width).each do |col_index|
        new_state[row_index][col_index] = judge.call(board, row_index, col_index)
      end
    end

    Board.new(board.width, board.height, 17, new_state)
  end

  def print(board)
    system "clear"
    puts(stringify_board.call(board))
  end
end

class Board
  attr_reader :state, :width, :height

  def initialize(width, height, seed, state = nil)
    @width = width
    @height = height
    @state = state || initialize_state(seed)
  end

  private

  def initialize_state(seed)
    gen = Random.new(seed)
    Array.new(height) { Array.new(width) { [true, false].sample(random: gen) } }
  end
end

class Judge
  def call(board, row_index, col_index)
    live_neighbour_count = 0

    ((row_index - 1)..(row_index + 1)).each do |neighbour_row_index|
      ((col_index - 1)..(col_index+1)).each do |neighbour_col_index|
        next if [row_index, col_index] == [neighbour_row_index, neighbour_col_index]

        if cell_exists?(board, neighbour_row_index, neighbour_col_index)
          live_neighbour_count += 1 if board.state[neighbour_row_index][neighbour_col_index]
        end
      end
    end

    case live_neighbour_count
    when 2 then board.state[row_index][col_index]
    when 3 then true
    else        false
    end
  end

  private

  def cell_exists?(board, row_index, col_index)
    return false unless (0...board.height).cover?(row_index)
    return false unless (0...board.width).cover?(col_index)
    true
  end
end

class StringifyBoard
  def call(board)
    output = ""

    board.state.each do |column|
      column.each do |cell|
        output << (cell ? "💜" : "💀")
      end

      output << "\n"
    end

    output
  end
end

Game.new.call(width: 80, height: 30, seed: 17)
