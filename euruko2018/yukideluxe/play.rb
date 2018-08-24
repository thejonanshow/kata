# Fewer than 2 neighbors will die.
# Exactly 3 neighbors will live.
# Greater than 3 neighbors will die.

# With 2 or 3 we live
# If we're dead and have exactly 3 we should live

class World
  def initialize
    @board = make_board
  end

  def make_board
    Array.new(10) { Array.new(10) }
  end

  def random_meeple
    x = rand(0..9)
    y = rand(0..9)

    while @board[x][y]
      x = rand(0..9)
      y = rand(0..9)
    end

    @board[x][y] = true
  end

  def play
    new_board = make_board

    @board.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell
          neighbors = 0

          [[0, 1], [1, 1], [1, 0], [-1, 0], [-1, 1], [-1, -1], [0, -1], [1, -1]].each do |coord|
            new_i = i + coord[0]
            new_j = j + coord[1]
            next if new_i < 0 || new_i > @board.size - 1 || new_j < 0 || new_j > @board.size - 1

            if @board[new_i][new_j]
              neighbors += 1
            end
          end

          # all the setting of meeples happens on the new board
          if neighbors == 2 || neighbors == 3
            new_board[i][j] = true
          end
        end
      end
    end

    @board = new_board
    puts self
  end

  def to_s
    @board.each do |row|
      row.each do |cell|
        print "#{cell ? '| X ' : '|   '}"
      end
      puts
      puts "-------------------------------------"
    end
  end
end

world = World.new
25.times { world.random_meeple }
puts world
world.play
world.play
