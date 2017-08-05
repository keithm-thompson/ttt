require 'rspec'
require './lib/tictactoe/players/base_player.rb'

class StubbedClass < BasePlayer
end

describe BasePlayer do
  let (:stubbed_class) do
    StubbedClass.new
  end

  describe '#mark' do
    it "will raise error if sub-class does not implement #mark" do
      expect { stubbed_class.mark }.to raise_error(NotImplementedError)
    end
  end

  describe '#name' do
    it "will raise error if sub-class does not implement #name" do
      expect { stubbed_class.name }.to raise_error(NotImplementedError)
    end
  end

  describe '#get_move' do
    it "will raise error if sub-class does not implement #get_move" do
      expect { stubbed_class.name }.to raise_error(NotImplementedError)
    end
  end
end
