require_relative './board.rb'
require_relative './players/human.rb'
require_relative './players/computer.rb'

class Game
  MARKS = {
    'X' => 1,
    'x' => 1,
    'O' => -1,
    'o' => -1
  }

  def self.create_player(type)
    type === "human" ? Human.new() : Computer.new()
  end

  def initialize(player1, player2, grid_len)
    @player1 = Game.create_player(player1)
    @player2 = Game.create_player(player2)
    @board = Board.new(grid_len)
  end
end
