require_relative '../tictactoe_graph_algo.rb'
require_relative '../tictactoe_io.rb'

class SmarterComputerPlayer < ComputerPlayer
  attr_reader :mark, :name
  def initialize(name, mark, board)
    super(name, mark, board)
    @graph = nil
  end

  def get_move
    if @graph
      @graph.get_next_move(@board.grid, @mark)
    elsif can_make_graph?
      TicTacToeIO.notify_creating_graph
      @graph = TicTacToeGraph.new(@board.length, @board.grid, @mark)
      get_move
    else
      super
    end
  end

private
  def can_make_graph?
    @board.available_spots.length < 10
  end
end
