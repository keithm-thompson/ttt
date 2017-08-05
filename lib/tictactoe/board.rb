require_relative './tictactoe_io.rb'
require 'set'
require 'byebug'

class Board
  attr_reader :available_spots
  def initialize(grid_len)
    @grid = Array.new(grid_len) { Array.new(grid_len, 0) }
    @available_spots = Set.new
    initialize_spot_set!
  end

  def filled?
    @available_spots.empty?
  end

  def length
    @grid.length
  end

  def mark(point, value)
    row, col = point
    @grid[row][col] = value
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
