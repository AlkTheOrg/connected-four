require 'spec_helper'

module ConnectedFour
  describe Player do
    context "#initialize" do
      it "raises an exception when initialized with {}" do
        expect { Player.new({}) }.to raise_error
      end
    end

    context "#color" do
      it "returns the color" do
        input = { color: "r", name: "Someone" }
        player = Player.new(input)
        expect(player.color).to eq('r')
      end
    end

    context "#name" do
      it "returns the name" do
        input = { color: "y", name: 'Someone' }
        player = Player.new(input)
        expect(player.name).to eq 'Someone'
      end
    end
  end
end
