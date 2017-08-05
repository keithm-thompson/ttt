require 'rspec'
require './lib/tictactoe/board.rb'

describe Board do
  let (:board) { Board.new(3) }
  describe '#initialize' do
    it 'sets a two-dimensional square array of the paramaters length' do
      grid = board.instance_variable_get(:@grid)
      expect(grid.length).to eq(3)
      expect(grid[0].length).to eq(3)
    end

    it 'creates an array of available moves with length paramater^2' do
      available_spots = board.instance_variable_get(:@available_spots)
      expect(available_spots.to_a.length).to eq(9)
    end
  end

  describe '#filled?' do
    context 'when available_spots is empty' do
      it 'returns true' do
        board.instance_variable_set(:@available_spots, [])
        expect(board.filled?).to eq(true)
      end
    end

    context 'when available_spots is not empty' do
      it 'returns false' do
        expect(board.filled?).to eq(false)
      end
    end
  end

  describe '#length' do
    it 'returns dimension of square grid' do
      expect(board.length).to eq(3)
    end
  end

  describe '#mark' do
    it 'marks a point on grid' do
      board.mark!([0,0], 1)
      grid = board.instance_variable_get(:@grid)
      expect(grid[0][0]).to eq(1)
    end

    it 'removes point from available_spots' do
      board.mark!([0,0], 1)
      available_spots = board.instance_variable_get(:@available_spots)
      expect(available_spots.include?([0,0])).to eq(false)
    end
  end

  describe '#print' do
    it 'calls TicTacToeIO::print_border #length + 1 times' do
      allow(TicTacToeIO).to receive(:print_border).and_return(nil)
      allow(TicTacToeIO).to receive(:print_row).and_return(nil)
      expect(TicTacToeIO).to receive(:print_border).exactly(board.length + 1).times
      board.print
    end
    it 'calls TicTacToeIO::print_row #length times' do
      allow(TicTacToeIO).to receive(:print_border).and_return(nil)
      allow(TicTacToeIO).to receive(:print_row).and_return(nil)
      expect(TicTacToeIO).to receive(:print_row).exactly(board.length).times
      board.print
    end
  end

  describe '#valid_move?' do
    context "when point hasn't been marked" do
      it "returns true" do
        expect(board.valid_move?([0,0])).to eq(true)
      end
    end

    context "when point has been marked" do
      it "returns false" do
        board.mark!([0,0], 1)
        expect(board.valid_move?([0,0])).to eq(false)
      end
    end
  end

end
