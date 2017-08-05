require_relative './io.rb'

class Board
  def initialize(grid_len)
    @grid = Array.new(grid_len, 0) { Array.new(grid_len, 0) }
  end

  def mark(point, value)
    @grid[point[0], point[1]] = value
  end

  def get(point)
    @grid[point[0], point[1]]
  end

  def valid_move?(move)
    self.get(move).zero?
  end

  def print
    IO.print_border
    @grid.each do |row|
      IO.print_row(row)
      IO.print_border(row.length)
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
