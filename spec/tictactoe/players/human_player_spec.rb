require 'rspec'
require "./lib/tictactoe/players/base_player.rb"
require './lib/tictactoe/players/human_player.rb'
require "./lib/tictactoe/board.rb"
require "./lib/tictactoe/tictactoe_io.rb"

describe HumanPlayer do
  let (:human) do
    board = double("Board", length: 5)
    HumanPlayer.new("Test", "X", board)
  end

  it 'inherits from BasePlayer' do
    expect(described_class).to be < BasePlayer
  end

  describe '#initialize' do
    it "sets appropriate values" do
      expect(human.instance_variable_get(:@name)).to eq("Test")
      expect(human.instance_variable_get(:@mark)).to eq("X")
      expect(human.instance_variable_get(:@board).class).to eq(double("Board").class)
    end
  end

  describe '#get_move' do
    let (:board) { human.instance_variable_get(:@board) }
    context 'when given an open spot' do
      it 'calls board#valid_move? once' do
        allow(TicTacToeIO).to receive(:get_move_from_player).and_return('testing')
        allow(board).to receive(:valid_move?).and_return(true)
        expect(board).to receive(:valid_move?).once
        human.get_move
      end
    end

    context 'when given a taken spot' do
      it 'calls board#valid_move? once' do
        allow(TicTacToeIO).to receive(:get_move_from_player).and_return('testing')
        allow(TicTacToeIO).to receive(:notify_invalid_move).and_return(nil)
        allow(board).to receive(:valid_move?).and_return(false, true)
        expect(TicTacToeIO).to receive(:notify_invalid_move).once
        expect(board).to receive(:valid_move?).twice
        human.get_move
      end
    end
  end
end
