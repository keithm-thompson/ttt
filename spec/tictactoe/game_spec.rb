require 'rspec'
require './lib/tictactoe/game.rb'
require './lib/tictactoe/players/human_player.rb'
require './lib/tictactoe/players/computer_player.rb'

describe Game do
  let (:human_hash) { { type:"human", mark: "X", name: "Test", board: double("Board") } }
  let (:computer_hash) { { type: "computer", mark: "O", name: "Test", board: double("Board") } }
  let (:game) { Game.new(3, human_hash, computer_hash) }
  let (:board) {double("Board")}
  describe '::create_player' do
    context "when given a type of human" do
      it "creates a HumanPlayer" do
        allow(HumanPlayer).to receive(:new).and_return(double("Human"))
        expect(HumanPlayer).to receive(:new).once
        Game.create_player(board, human_hash)
      end
    end

    context "when given a type of computer" do
      it "creates a ComputerPlayer" do
        allow(ComputerPlayer).to receive(:new).and_return(double("Computer"))
        expect(ComputerPlayer).to receive(:new).once
        Game.create_player(board, computer_hash)
      end
    end

    context "when given a mark of 'X'" do
      it "sets Player#mark to 1" do
        allow(HumanPlayer).to receive(:new).and_return(double("Human"))
        expect(HumanPlayer).to receive(:new).once.with("Test",1,anything)
        Game.create_player(board, human_hash)
      end
    end

    context "when given a mark of 'O'" do
      it "sets Player#mark to -1" do
        allow(ComputerPlayer).to receive(:new).and_return(double("Computer"))
        expect(ComputerPlayer).to receive(:new).once.with("Test", -1, anything)
        Game.create_player(board, computer_hash)
      end
    end
  end

  describe '#initialize' do
    it 'sets appropriate values' do
      player1 = game.instance_variable_get(:@player1)
      player2 = game.instance_variable_get(:@player2)
      current_player = game.instance_variable_get(:@current_player)
      sums = game.instance_variable_get(:@sums)

      expect(game.instance_variable_get(:@board).class).to eq(Board)
      expect(player1.class).to eq(HumanPlayer)
      expect(player2.class).to eq(ComputerPlayer)
      expect([player1.class, player2.class].include?(current_player.class)).to eq(true)
      expect(game.instance_variable_get(:@is_over)).to eq(false)
      expect(game.instance_variable_get(:@winner)).to eq(nil)
      expect(sums[:row_sums].length).to eq(3)
      expect(sums[:col_sums].length).to eq(3)
      expect(game.instance_variable_get(:@row_length)).to eq(3)
    end
  end

  describe '#display_current_state' do
    it 'calls board#print' do
      expect(game.instance_variable_get(:@board)).to receive(:print)
      game.display_current_state
    end
  end

  describe '#over?' do
    context "when @is_over is true" do
      it "returns true" do
        game.instance_variable_set(:@is_over, true)
        expect(game.over?).to eq(true)
      end
    end

    context "when @is_over is false" do
      it "returns false" do
        game.instance_variable_set(:@is_over, false)
        expect(game.over?).to eq(false)
      end
    end
  end

  describe "#play_round!" do
    let(:current_player) { game.instance_variable_get(:@current_player) }
    let(:board) { game.instance_variable_get(:@board) }

    it "calls board#mark!" do
      allow(current_player).to receive(:get_move).and_return(nil)
      allow(current_player).to receive(:mark).and_return(nil)
      allow(game).to receive(:record_mark!).and_return(nil)
      allow(board).to receive(:mark!).and_return(nil)

      expect(board).to receive(:mark!)
      game.play_round!
    end

    it "swaps players" do
      allow(current_player).to receive(:get_move).and_return(nil)
      allow(current_player).to receive(:mark).and_return(nil)
      allow(game).to receive(:record_mark!).and_return(nil)
      allow(board).to receive(:mark!).and_return(nil)

      game.play_round!
      next_player = game.instance_variable_get(:@current_player)
      expect(next_player).to_not eq(current_player)
    end

    context "when game ends with a winner on round" do
      before(:each) do
        allow(current_player).to receive(:get_move).and_return([0,0], [2,2])
        allow(current_player).to receive(:mark).and_return(1)
        allow(board).to receive(:mark!).and_return(nil)
        game.play_round!

        next_player = game.instance_variable_get(:@current_player)
        allow(next_player).to receive(:get_move).and_return([1,1])
        allow(next_player).to receive(:mark).and_return(1)
        game.play_round!
        game.play_round!
      end

      it "sets game over to true" do
        expect(game.over?).to eq(true)
      end

      it "sets the correct winner" do
        expect(game.winner).to eq(current_player)
      end
    end

    context "when game ends in a tie on round" do
      before(:each) do
        allow(current_player).to receive(:get_move).and_return([0,0])
        allow(current_player).to receive(:mark).and_return(1)
        allow(board).to receive(:mark!).and_return(nil)
        allow(board).to receive(:filled?).and_return(true)
        game.play_round!
      end

      it "sets game over to true" do
        expect(game.over?).to eq(true)
      end

      it "does not set a winner" do
        expect(game.winner).to eq(nil)
      end
    end

    context "when there is not yet a winner and the board is not filled" do
      before(:each) do
        allow(current_player).to receive(:get_move).and_return([0,0])
        allow(current_player).to receive(:mark).and_return(1)
        allow(board).to receive(:mark!).and_return(nil)
        allow(board).to receive(:filled?).and_return(false)
        game.play_round!
      end

      it "does not set game over to true" do
        expect(game.over?).to eq(false)
      end

      it "does not set a winner" do
        expect(game.winner).to eq(nil)
      end
    end
  end
end
