require_relative "./base_player"

class ComputerPlayer < BasePlayer
  attr_reader :mark, :name
  def initialize(name, mark, board)
    @name = name
    @mark = mark
    @board = board
  end

  def get_move
    generate_random_move
  end

  private
  def generate_random_move
    @board.available_spots.to_a.sample
  end
end
