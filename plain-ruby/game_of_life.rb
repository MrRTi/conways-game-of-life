class GameOfLife
  PERCENTAGE_OF_DEAD_CELLS_AT_START = 90
  FREEZE_FRAME_SECONDS = 0.2
  ROWS_COUNT = 20
  COLUMNS_COUNT = 150
  ALIVE_CELL_SYMBOL = "@"
  DEAD_CELL_SYMBOL = " "

  def initialize
    @grid = generate
  end

  attr_reader :grid

  def run
    generation = 0
    init_alive_cells_count = grid.keys.size
    alive_cells = init_alive_cells_count

    while(alive_cells > 0) do
     render_frame
     alive_cells = grid.keys.size
     p "Game of life. Generation # #{generation}"
     p "Alive cells: #{alive_cells}. Diff from start: #{alive_cells - init_alive_cells_count}"
     p "Press Ctrl+C to exit"


     calculate_next_generation
     generation += 1
     sleep(FREEZE_FRAME_SECONDS)
    end

    clear_screen
    p "All cells are dead. Game over"
  end

  private

  def render_frame
    clear_screen
    printf grid_as_string 
  end

  def clear_screen
    puts `clear`
  end

  def calculate_next_generation
    new_grid = {}
    (0..ROWS_COUNT).each do |row|
      (0..COLUMNS_COUNT).each do |column|
        new_grid[[row, column]] = true if cell_next_state(row, column)
      end
    end

    @grid = new_grid
  end

  def cell_next_state(row, column)
    alive = grid[[row, column]]
    alive_neighbours_count = alive_neighbours_count(row, column)
    alive_neighbours_count === 3 || alive && alive_neighbours_count === 2
  end

  def alive_neighbours_count(row, column)
    [-1, 0, 1].reduce(0) do |acc, row_offset|
      column_count = [-1, 0, 1].reduce(0) do |acc, column_offset|
        same_cell = [row_offset, column_offset].all? {|offset| offset === 0 }
        neighbour_alive = grid[[row + row_offset, column + column_offset]]
        next acc if same_cell
        
        neighbour_alive ? acc + 1 : acc
      end

      acc + column_count
    end
  end

  def grid_as_string
    (0..ROWS_COUNT).reduce("") do |acc, row|
      column = (0..COLUMNS_COUNT).reduce("") do |acc, column|
        cell = grid[[row,column]] ? ALIVE_CELL_SYMBOL : DEAD_CELL_SYMBOL
        acc + cell
      end

      acc + column + "\n"
    end
  end

  def generate
    new_grid = {}

    (0..ROWS_COUNT).each do |row|
      (0..COLUMNS_COUNT).each do |column|
        alive = rand(100) > PERCENTAGE_OF_DEAD_CELLS_AT_START
        new_grid[[row, column]] = true if alive
      end
    end

    @grid = new_grid
  end
end

game = GameOfLife.new
game.run
