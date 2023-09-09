# frozen_string_literal: true

# This is Conways game of life
class GameOfLife
  PERCENTAGE_OF_DEAD_CELLS_AT_START = 90
  FREEZE_FRAME_SECONDS = 0.2
  ROWS_COUNT = 20
  COLUMNS_COUNT = 150
  ALIVE_CELL_SYMBOL = '@'
  DEAD_CELL_SYMBOL = ' '

  def initialize
    @grid = generate
    @init_alive_cells_count = alive_cells
    @generation = 0
  end

  attr_reader :grid, :generation, :init_alive_cells_count

  def run
    render_loop

    game_over
  end

  private

  def alive_cells
    grid.keys.size
  end

  def render_loop
    while alive_cells.positive?
      render_frame

      calculate_next_generation
      @generation += 1
      sleep(FREEZE_FRAME_SECONDS)
    end
  end

  def render_frame
    clear_screen
    printf grid_as_string
    render_info_lines
  end

  def clear_screen
    puts `clear`
  end

  def render_info_lines
    p "Game of life. Generation # #{generation}"
    p "Alive cells: #{alive_cells}. Diff from start: #{alive_cells - init_alive_cells_count}"
    p 'Press Ctrl+C to exit'
  end

  def game_over
    clear_screen
    p 'All cells are dead. Game over'
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
    alive_neighbours_count == 3 || alive && alive_neighbours_count == 2
  end

  def alive_neighbours_count(row, column)
    [-1, 0, 1].reduce(0) do |count, row_offset|
      row_count = [-1, 0, 1].reduce(0) do |columns_count, column_offset|
        same_cell = [row_offset, column_offset].all?(&:zero?)
        neighbour_alive = grid[[row + row_offset, column + column_offset]]
        next columns_count if same_cell

        neighbour_alive ? columns_count + 1 : columns_count
      end

      count + row_count
    end
  end

  def grid_as_string
    (0..ROWS_COUNT).reduce('') do |acc_row, row|
      column_str = (0..COLUMNS_COUNT).reduce('') do |acc_column, column|
        cell = grid[[row, column]] ? ALIVE_CELL_SYMBOL : DEAD_CELL_SYMBOL
        acc_column + cell
      end

      "#{acc_row}#{column_str}\n"
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
