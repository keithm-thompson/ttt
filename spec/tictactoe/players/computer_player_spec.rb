require 'rspec'
require "./lib/tictactoe/players/base_player.rb"
require './lib/tictactoe/players/computer_player.rb'
require "./lib/tictactoe/board.rb"

describe ComputerPlayer do
  let (:computer) do
    board = double("Board")
    ComputerPlayer.new("Test", "X", board)
  end

  it 'inherits from BasePlayer' do
    expect(described_class).to be < BasePlayer
  end

  describe '#initialize' do
    it "sets appropriate values" do
      expect(computer.instance_variable_get(:@name)).to eq("Test")
      expect(computer.instance_variable_get(:@mark)).to eq("X")
      expect(computer.instance_variable_get(:@board).class).to eq(double("Board").class)
    end
  end

  describe '#get_move' do
    let (:board) { computer.instance_variable_get(:@board) }
    it 'calls board#available_spots' do
      allow(board).to receive(:available_spots).and_return([])
      computer.get_move
    end
  end
end
