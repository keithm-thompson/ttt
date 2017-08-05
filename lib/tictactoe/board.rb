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

  def filled?
    @available_spots.empty?
  end

  def get(point)
    @grid[point[0], point[1]]
  end

  def mark(point, value)
    @grid[point[0], point[1]] = value
    remove_point_from_availabilities(point)
  end


  def print
    TicTacToeIO.print_border(@grid.length)
    @grid.each do |row|
      TicTacToeIO.print_row(row)
      TicTacToeIO.print_border(@grid.length)
    end
  end

  def valid_move?(move)
    @available_spots.include?(move)
  end
  private

  def []=(row, col, value)
    @grid[row][col]
  end

  def initialize_spot_set!
    for i in 0...@grid.length
      for j in 0...@grid.length
        @available_spots.add([i,j])
      end
    end
  end

  def remove_point_from_availabilities(point)
    @available_spots.delete(point)
  end
end
