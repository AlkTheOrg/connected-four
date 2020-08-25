require 'spec_helper'

module ConnectedFour
  describe Cell do
    context "#initialize" do
      it "is initialized with a default value '' " do
        cell = Cell.new
        expect(cell.value).to eq ''
      end
      
      it "is initialized with a parameter value" do
        cell = Cell.new('R')
        expect(cell.value).to eq 'R'
      end
    end
  end
end
