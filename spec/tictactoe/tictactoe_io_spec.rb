require 'rspec'
require './lib/tictactoe/tictactoe_io.rb'

describe TicTacToeIO do
  let(:player) { double("Player") }
  before(:each) { allow(player).to receive(:name).and_return("test") }

  describe "::display_results" do
    context "when given a winner" do
      it "displays winner" do
        expect(STDOUT).to receive(:puts).with("test wins! Good job!")
        TicTacToeIO.display_results(player)
      end

      it "doesn't display tie" do
        expect(STDOUT).to_not receive(:puts).with("The game ended in a tie! Well played.")
        TicTacToeIO.display_results(player)
      end
    end

    context "when not given a winner" do
      it "displays tie message" do
        expect(STDOUT).to receive(:puts).with("The game ended in a tie! Well played.")
        TicTacToeIO.display_results(nil)
      end

      it "doesn't display a winner" do
        expect(STDOUT).to_not receive(:puts).with("test wins! Good job!")
        TicTacToeIO.display_results(nil)
      end
    end
  end

  describe "::display_beginning_of_round" do
    it "prints current players name and current config of board" do
      expect(STDOUT).to receive(:puts).with("It's test's turn. Good luck!")
      expect(STDOUT).to receive(:puts).with("Here is the current state of the board:")
      TicTacToeIO.display_beginning_of_round(player)
    end
  end

  describe "::get_move_from_player" do
    after(:each) {TicTacToeIO.get_move_from_player(3)}
    it "asks user for input" do
      allow(TicTacToeIO).to receive(:valid_move_input?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:gets)
    end

    it "checks if input is valid" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:valid_move_input?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:valid_move_input?)
    end

    it "correctly classifies invalid input" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:gets).and_return("0,a", "0,0")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:notify_invalid_input)
    end

    context "when given invalid input" do
      it "notifies user" do
        allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
        allow(TicTacToeIO).to receive(:gets).and_return("0,0")
        allow(TicTacToeIO).to receive(:valid_move_input?).and_return(false, true)
        allow(STDOUT).to receive(:puts).and_return("Oops! Looks like that input was invalid.")

        expect(STDOUT).to receive(:puts).with("Oops! Looks like that input was invalid.")
      end
    end
  end

  describe "::get_player_mark" do
    after(:each) {TicTacToeIO.get_player_mark}
    it "asks user for input" do
      allow(TicTacToeIO).to receive(:valid_mark?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:gets)
    end

    it "checks if input is valid" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:valid_mark?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:valid_mark?)
    end

    it "correctly classifies invalid input" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:gets).and_return("a", "X")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:notify_invalid_input)
    end

    context "when given invalid input" do
      it "notifies user" do
        allow(STDOUT).to receive(:puts).and_return("Oops! Looks like that input was invalid.")
        allow(TicTacToeIO).to receive(:valid_mark?).and_return(false, true)
        allow(TicTacToeIO).to receive(:gets).and_return("0,0")
        expect(STDOUT).to receive(:puts).with("Oops! Looks like that input was invalid.")
      end
    end
  end

  describe "::get_grid_length" do
    after(:each) {TicTacToeIO.get_grid_length}
    it "asks user for input" do
      allow(TicTacToeIO).to receive(:valid_grid_length?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:gets)
    end

    it "checks if input is valid" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:valid_grid_length?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:valid_grid_length?)
    end

    it "correctly classifies invalid input" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:gets).and_return("2", "3")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:notify_invalid_input)
    end

    context "when given invalid input" do
      it "notifies user" do
        allow(STDOUT).to receive(:puts).and_return("Oops! Looks like that input was invalid.")
        allow(TicTacToeIO).to receive(:valid_grid_length?).and_return(false, true)
        allow(TicTacToeIO).to receive(:gets).and_return("0,0")

        expect(STDOUT).to receive(:puts).with("Oops! Looks like that input was invalid.")
      end
    end
  end

  describe "::greet" do
    it "greets the user" do
      expect(STDOUT).to receive(:puts).with("Time to play TicTacToe!")
      TicTacToeIO.greet
    end
  end

  describe "::notify_invalid_move" do
    it "notifies the user" do
      expect(STDOUT).to receive(:puts).with("Oops! Looks like that point on the grid has already been played.")
      TicTacToeIO.notify_invalid_move
    end
  end

  describe "::play_again?" do
    after(:each) {TicTacToeIO.play_again?}
    it "asks user for input" do
      allow(TicTacToeIO).to receive(:valid_player_input?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:gets)
    end

    it "checks if input is valid" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:valid_player_input?).and_return(true)
      allow(TicTacToeIO).to receive(:gets).and_return("0,0")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:valid_player_input?)
    end

    it "correctly classifies invalid input" do
      allow(TicTacToeIO).to receive(:format_move_input).and_return(nil)
      allow(TicTacToeIO).to receive(:gets).and_return("2", "n")
      allow(STDOUT).to receive(:puts).and_return(nil)

      expect(TicTacToeIO).to receive(:notify_invalid_input)
    end

    context "when given invalid input" do
      it "notifies user" do
        allow(STDOUT).to receive(:puts).and_return("Oops! Looks like that input was invalid.")
        allow(TicTacToeIO).to receive(:valid_player_input?).and_return(false, true)
        allow(TicTacToeIO).to receive(:gets).and_return("0,0")
        
        expect(STDOUT).to receive(:puts).with("Oops! Looks like that input was invalid.")
      end
    end

    context "when given valid input" do
      it "returns true" do
        allow(STDOUT).to receive(:puts).and_return(nil)
        allow(TicTacToeIO).to receive(:gets).and_return("y")
        expect(TicTacToeIO.play_again?).to eq(true)
      end
    end
  end

  describe "::print_border" do
    it "prints a border of correct length" do
      expect(STDOUT).to receive(:puts).with(" - - - - ")
      TicTacToeIO.print_border(2)
    end
  end

  describe "::print_row" do
    it "prints a row with correct output" do
      expect(STDOUT).to receive(:puts).with("| X |   |   |")
      TicTacToeIO.print_row([1, 0, 0])
    end
  end
end
