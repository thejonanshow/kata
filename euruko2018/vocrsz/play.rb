class Cell
  ALIVE = :alive
  DEAD = :dead

  def initialize(state = ALIVE)
    @state = state
  end

  def live!
    @state = Cell::ALIVE
  end

  def alive?
    @state == ALIVE
  end

  def to_s
    if @state == ALIVE
      "X"
    else
      "-"
    end
  end
end

class World
  def initialize
    @width = 10
    @height = 10

    @something = something_maker

    populate
  end
  
  def something_maker
    Array.new(@width) { Array.new(@height) { Cell.new(Cell::DEAD) } }
  end

  # Fewer than 2 neighbors will die.
  # Exactly 3 neighbors will live.
  # Greater than 3 neighbors will die.

  def step
    new_something = something_maker

    @something.each.with_index do |row, row_index|
      row.each.with_index do |cell, column_index|
        count = neighbor_count(row_index, column_index)

        if count > 3 || count < 2
          new_something[row_index][column_index] = Cell.new(Cell::DEAD)
        else
          new_something[row_index][column_index] = Cell.new(Cell::ALIVE) if cell.alive?
        end
      end
    end

    @something = new_something
  end

  def neighbor_count(row, column)
    count = 0

    [-1, 0, 1].each do |row_offset|
      [-1, 0, 1].each do |column_offset|
        next if row_offset == 0 && column_offset == 0
        next if (row + row_offset) < 0 || (row + row_offset) > @width - 1
        next if (column + column_offset) < 0 || (column + column_offset) > @height - 1

        if @something[row + row_offset][column + column_offset].alive?
          count += 1
        end
      end
    end

    count
  end

  def show
    puts "*******"
    @something.each do |row|
      row.each do |cell|
        print cell
      end

      puts
    end
  end

  def populate
    @something.each do |row|
      row.each do |cell|
        cell.live! if rand(1..2) == 2 
      end
    end
  end
end

world = World.new

10.times do
  system "clear"
  world.show
  world.step
  sleep 1
end

world.show
