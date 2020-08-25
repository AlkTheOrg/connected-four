require 'spec_helper'

module ConnectedFour
  describe Board do
    context "#initialize" do
      it "is initializes board with a grid" do
        expect { Board.new(grid: 'grid') }.to_not raise_error
        # pay attention that it has a square bracket as it is a code block
      end

      it "sets a grid with 6 rows by default" do
        board = Board.new
        expect(board.grid.size).to eql 6
      end

      it "sets a grid with 7 columns by default" do
        board = Board.new
        board.grid.each do |row|
          expect(row.size).to eql 7
        end
      end
    end

    context "#grid" do
      it "returns the grid" do
        board = Board.new(grid: "my_grid")
        expect(board.grid).to eql 'my_grid'
      end
    end

    context "#get_cell" do
      it "returns the cell based on (x, y) values" do
       grid = [['', 'some_value', '', '', '', '', '']]
       (0..6).each { grid.push(['', '', '', '', '', '', ''])}
       board = Board.new(grid: grid)
       expect(board.get_cell(0, 1)).to eql 'some_value' 
      end

      it "raises error on an out of bounds index" do
        board = Board.new
        expect { board.get_cell(-1, -1) }.to raise_error
      end
    end

    context "#set_cell" do
      it "sets the value of a cell based in (x, y) values" do
        Cell = Struct.new(:value)
        grid = [['', Cell.new('hey'), '', '', '', '', '']]
        (0..5).each { grid.push(['', '', '', '', '', '', ''])}
        board = Board.new(grid: grid)
        board.set_cell(0, 1, 'bye')
        expect(board.get_cell(0, 1).value).to eq 'bye'
      end
    end

    context "#column_has_space?" do
      Cell = Struct.new(:value)
      let(:empty) { Cell.new }
      let(:red_cell) { Cell.new('r') }

      it "returns true if there is an empty space in given column" do
        grid = [[empty, empty, empty, empty, empty, empty, empty]]
        (1..5).each { grid.push([red_cell, empty, empty, empty, empty, empty, empty]) }
        board = Board.new(grid: grid)
        expect(board.column_has_space?(0)).to be_truthy
      end

      it "returns false if there is not an empty space in given column" do
        grid = []
        (1..6).each { grid.push([red_cell, empty, empty, empty, empty, empty])}
        board = Board.new(grid: grid)
        expect(board.column_has_space?(0)).to be_falsey
      end
    end

    context "#drop_disc_to" do
      Cell = Struct.new(:value)
      let(:empty) { Cell.new }
      let(:red_cell) { Cell.new('r') }

      it "adds the value to the last empty cell to the given column num if there is space" do
        grid = [[empty, empty, empty, empty, empty, empty, empty], 
                [empty, empty, empty, empty, empty, empty, empty], 
                [empty, empty, empty, empty, empty, empty, empty], 
                [empty, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty]]
        board = Board.new(grid: grid)
        board.drop_disc_to(0, 'r')
        expect(board.get_cell(2, 0).value).to eql 'r'
      end

      it "returns true if the operation is success" do
        grid = [[empty, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty]]
        board = Board.new(grid: grid)
        expect(board.drop_disc_to(0, 'r')).to be_truthy
      end

      it "returns false if the operation is failure" do
        grid = [[red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty]]
        board = Board.new(grid: grid)
        expect(board.drop_disc_to(0, 'r')).to be_falsey
      end
    end

    context "#game_over" do
      Cell = Struct.new(:value)
      let(:red_cell) { Cell.new('R') }  
      let(:yellow_cell) { Cell.new('Y') }
      let(:empty) { Cell.new }

      it "returns :winner if winner is true" do
        board = Board.new
        allow(board).to receive(:winner?).and_return(true)
        expect(board.game_over).to eql :winner
      end

      it "returns :draw if winner is false, but draw is true" do
        board = Board.new
        allow(board).to receive(:winner?).and_return(false)
        allow(board).to receive(:draw?).and_return(true)
        expect(board.game_over).to eql :draw
      end

      it "returns false if both winner? and draw? returns false" do
        board = Board.new
        allow(board).to receive(:winner?).and_return(false)
        allow(board).to receive(:draw?).and_return(false)
        expect(board.game_over).to be_falsey
      end

      it "returns :winner when there are 4 connected same values in a row" do
        grid = [[red_cell, red_cell, red_cell, red_cell, empty, empty, empty]]
        (1..5).each { grid.push([empty, empty, empty, empty, empty, empty, empty]) }
        board = Board.new(grid: grid)
        expect(board.game_over).to eql :winner
      end

      it "returns :winner when there are 4 connected same values in a column" do
        grid = [[empty, empty, empty, empty, empty, empty, empty], 
                [empty, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty],
                [red_cell, empty, empty, empty, empty, empty, empty], 
                [red_cell, empty, empty, empty, empty, empty, empty]]
        board = Board.new(grid: grid)
        expect(board.game_over).to eql :winner
      end

      it "returns :winner when there are 4 connected same values in a diagonal" do
        grid =            [[empty, empty, empty, empty, empty, empty, empty], 
                           [empty, empty, empty, empty, empty, empty, empty], 
                           [empty, empty, empty, red_cell, empty, empty, empty], 
                        [empty, empty, red_cell, red_cell, empty, empty, empty], 
                     [empty, red_cell, red_cell, red_cell, empty, empty, empty], 
                  [red_cell, red_cell, red_cell, red_cell, empty, empty, empty]]
        board = Board.new(grid: grid)
        expect(board.game_over).to eql :winner
      end

      it "returns :draw when all values are taken in the grid" do
        grid = [[red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell], 
                [red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell], 
                [yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell], 
                [yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell],
                [red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell], 
                [red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell]]
        board = Board.new(grid: grid)
        expect(board.game_over).to eql :draw
      end

      it "returns false when there neither a winner nor draw situation" do
        grid = [[red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, empty], 
                [red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, empty], 
                [yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell, empty], 
                [yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, red_cell, empty],
                [red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, empty], 
                [red_cell, yellow_cell, red_cell, yellow_cell, red_cell, yellow_cell, empty]]
        board = Board.new(grid: grid)
        expect(board.game_over).to be_falsey
      end
    end
  end
end
