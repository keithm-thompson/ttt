require_relative "./base_player"

class ComputerPlayer < BasePlayer
  attr_reader :mark
  def initialize(board, mark)
    @board = board
    @mark = mark
  end

  def perform_move
    move = self.generate_random_move
    @board.mark(move, @mark)
  end

  private

  def generate_random_move
    row, col = rand(@board.length), rand(@board.length)
    until @board.valid_move?([row,col])
      row, col = rand(@board.length), rand(@board.length)
    end
    [row,col]
  end
end
