require 'rspec'
require './lib/tictactoe/main.rb'
require './lib/tictactoe/tictactoe_io.rb'
require './lib/tictactoe/game.rb'

describe Main do
  let(:game) { Game.new }
  before(:each) do
    allow(Game).to receive(:new).and_return({})
  end
  describe '::start_game' do
    before(:each) do
      allow(TicTacToeIO).to receive(:greet).and_return(nil)
      allow(TicTacToeIO).to receive(:get_grid_length).and_return(nil)
      allow(Main).to receive(:get_player_information).and_return(nil)
      allow(Game).to receive(:new).and_return(nil)
      allow(Main).to receive(:play).and_return(nil)
    end

    it 'creates a new game' do
      expect(Game).to receive(:new)
      Main.start_game
    end

    it "plays the game" do
      expect(Main).to receive(:play)
      Main.start_game
    end
  end

  describe "::get_player_information" do
    before(:each) do
      allow(TicTacToeIO).to receive(:get_player_name).and_return("Test")
      allow(TicTacToeIO).to receive(:get_player_type).and_return("human")
      allow(TicTacToeIO).to receive(:get_player_mark).and_return("X")
      allow(STDOUT).to receive(:puts).and_return("The following information is for the first player.")
    end
    after(:each) { Main.get_player_information("first", true)}
    
    it "displays which player the information is for" do
      expect(STDOUT).to receive(:puts).with("The following information is for the first player.")
    end

    it "calls TicTacToeIO::get_player_type" do
      expect(TicTacToeIO).to receive(:get_player_type)
    end

    it "calls TicTacToeIO::get_player_name" do
      expect(TicTacToeIO).to receive(:get_player_name)
    end

    it "calls TicTacToeIO::get_player_mark" do
      expect(TicTacToeIO).to receive(:get_player_mark)
    end

    it "returns an object with player information" do
      info = Main.get_player_information("first", true)
      expect(info).to eq({ name: "Test", type: "human", mark: "X" })
    end
  end

  describe "::play" do
    before(:each) do
      allow(game).to receive(:display_current_state).and_return(nil)
      allow(TicTacToeIO).to receive(:display_results).and_return(nil)
      allow(Main).to receive(:play_round).and_return(nil)
      allow(game).to receive(:winner).and_return(nil)
    end

    context "when game is not over" do
      it "calls Main::play_round until game is over" do
        allow(game).to receive(:over?).and_return(false, false, true)
        allow(TicTacToeIO).to receive(:play_again?).and_return(false)

        expect(game).to receive(:over?).exactly(3).times
        expect(Main).to receive(:play_round).twice

        Main.play(game)
      end
    end

    context "when game is over" do
      before(:each) do
        allow(game).to receive(:over?).and_return(true)
        allow(TicTacToeIO).to receive(:play_again?).and_return(false)
      end

      after(:each) do
        Main.play(game)
      end
      it "displays results" do
        expect(TicTacToeIO).to receive(:display_results)
      end

      it "displays the final configuration of the board" do
        expect(TicTacToeIO).to receive(:display_results)
      end

      it "asks the user if they would like to play again" do
        expect(TicTacToeIO).to receive(:play_again?)
      end
    end

    context "if the user would like to play again" do
      before(:each) do
        allow(game).to receive(:over?).and_return(true)
      end

      after(:each) do
        Main.play(game)
      end

      it "starts the game" do
        allow(TicTacToeIO).to receive(:play_again?).and_return(true)
        expect(Main).to receive(:start_game)
      end
    end

    context "if the user would not like to play again" do
      it "does not start the game" do
        allow(TicTacToeIO).to receive(:play_again?).and_return(false)
        expect(Main).to_not receive(:start_game)
      end
    end
  end

  describe '::play_round' do
    before(:each) do
      allow(TicTacToeIO).to receive(:display_beginning_of_round).and_return(nil)
      allow(game).to receive(:play_round).and_return(nil)
      allow(game).to receive(:display_current_state).and_return(nil)
      allow(game).to receive(:current_player).and_return(nil)
    end

    it 'calls Game#play_round' do
      expect(game).to receive(:play_round)
      Main.play_round(game)
    end

    it 'displays current state of game' do
      expect(game).to receive(:display_current_state)
      Main.play_round(game)
    end

    it "prints who's turn it is" do
      expect(TicTacToeIO).to receive(:display_beginning_of_round)
      Main.play_round(game)
    end
  end
end
