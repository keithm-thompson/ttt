require_relative './tictactoe_io.rb'
require_relative 'set'

class Board
  attr_reader :available_spots
  def initialize(grid_len)
    @grid = Array.new(grid_len, 0) { Array.new(grid_len, 0) }
    @available_spots = Set.new
    initialize_spot_set!
  end
  
  def [](row, col)
    @grid[row][col]
  end

  def get(point)
    @grid[point[0], point[1]]
  end

  def mark(point, value)
    @grid[point[0], point[1]] = value
  end


  def valid_move?(move)
    self.get(move).zero?
  end

  def print
    TicTacToeIO.print_border(@grid.length)
    @grid.each do |row|
      TicTacToeIO.print_row(row)
      TicTacToeIO.print_border(@grid.length)
    end
  end

  private

  def []=(row, col, value)
    @grid[row][col]
  end

  def initialize_spot_set
    # STUB OUT
  end
end
