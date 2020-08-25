module ConnectedFour
  require 'pry'
  class Board
    attr_reader :grid
    def initialize(input = {})
      @grid = input.fetch(:grid, default_grid)
    end

    def get_cell(x, y)
      raise StandardError, 'Invalid cell index' unless valid_cell_index(x, y)

      grid[x][y]
    end

    def set_cell(x, y, value)
      grid[x][y].value = value
    end

    def game_over
      return :winner if winner?
      return :draw if draw?
      false
    end

    def formatted_grid
      grid.each do |row|
        puts row.map { |cell| cell.value.to_s.empty? ? "\u25CB" : cell.value }.join(' ')
      end
    end

    def column_has_space?(column_num)
      raise StandardError, 'Invalid column num' unless valid_column(column_num)

      column = grid.transpose[column_num]
      column.any? { |cell| cell.value.to_s.empty? }
    end

    def drop_disc_to(column_num, value)
      if column_has_space?(column_num)
        row_num = last_empty_row_in(column_num)
        grid[row_num][column_num].value = value
        true
      else
        false
      end
    end

    private

    def default_grid
      Array.new(6) { Array.new(7) { Cell.new } }
    end

    def draw?
      grid.flatten.map(&:value).none_empty?
    end

    def winner?
      winning_positions.each do |winning_position|
        next if winning_position_values(winning_position).all_empty?
        return true if winning_position_values(winning_position).all_same?
      end
      false
    end

    def winning_position_values(winning_position)
      winning_position.map(&:value)
    end

    def winning_positions
      grid_in_pieces + # merging different 2 dim arrays
        grid_transpose_in_pieces +
        diagonals_in_pieces
    end

    def grid_in_pieces
      array_in_pieces_of_four(grid)
    end

    def grid_transpose_in_pieces
      array_in_pieces_of_four(grid.transpose)
    end

    def diagonals_in_pieces
      array_in_pieces_of_four(diagonals)
    end

    # it collects each 4 connected cells from each diagonal and returns them in an array
    def array_in_pieces_of_four(array_double_dim)
      positions = []
      array_double_dim.each do |row|
        (0..row.size - 4).each { |i| positions.push(row[i..i + 3]) }
      end
      positions
    end

    # returns an array which contains all diagonal arrays with size bigger than 3
    def diagonals
      row_len = grid.size; col_len = grid[0].size
      diagonals_arr = []
      (3...row_len).each { |i| diagonals_arr.push(get_diagonal_left_to_right(i, 0, 0)) }
      (1...col_len - 3).each { |i| diagonals_arr.push(get_diagonal_left_to_right(row_len - 1, i, i - 1)) }
      diagonals_arr
    end

    def get_diagonal_left_to_right(row1, col1, row2)
      diagonal = []
      until row1 == row2 - 1
        diagonal.push(grid[row1][col1])
        row1 -= 1
        col1 += 1
      end
      diagonal
    end

    def valid_cell_index(row_num, column_num)
      valid_row(row_num) && valid_column(column_num) ? true : false
    end

    def valid_row(row_num)
      row_num.negative? || row_num >= grid.size ? false : true
    end

    def valid_column(column_num)
      column_num.negative? || column_num >= grid[0].size ? false : true
    end

    def last_empty_row_in(column_num)
      (grid.size - 1).downto(0).each do |i|
        return i if grid[i][column_num].value.to_s.empty?
      end
    end
  end
end
