require_relative './io.rb'

class Board
  def initialize(grid_len)
    @grid = Array.new(grid_len, 0) { Array.new(grid_len, 0) }
  end

  def mark(point, value)
    @grid[point[0], point[1]] = value
  end

  def check(point)
    @grid[point[0], point[1]]
  end

  def is_valid?(move)
    check(move).zero?
  end

  def print
    grid.each do |row|
      IO.print_row(row)
    end
  end

  private
  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, value)
    @grid[row][col]
  end
end
