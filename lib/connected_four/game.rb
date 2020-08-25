module ConnectedFour
  class Game
    attr_reader :players, :board, :current_player, :other_player
    def initialize(players, board = Board.new)
      @players = players
      @board = board
      @current_player, @other_player = players.shuffle
    end

    def play
      puts "#{current_player.name} has randomly been selected as the first player"
      loop do
        board.formatted_grid
        puts ''
        puts solicit_move
        column_no = get_move
        column_no = get_move until valid_move(column_no)
        board.drop_disc_to(column_no, current_player.color)
        if board.game_over
          puts game_over_message
          board.formatted_grid
          return
        else
          switch_players
        end
      end
    end

    def solicit_move
      "#{current_player.name}: Choose a column number between 1 and 7 to put your disc in it."
    end

    def get_move(move = gets.chomp)
      move.to_i - 1
    end

    def game_over_message
      return "#{current_player.name} won!" if board.game_over == :winner
      return 'The game ended in a tie' if board.game_over == :draw
    end

    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    private

    def valid_move(column_no)
      if !is_number?(column_no)
        puts 'Not a number'
        false
      elsif column_no.to_i < 0 || column_no.to_i > 6
        puts "#{column_no + 1} is not in the range of columns."
        false
      elsif !board.column_has_space?(column_no.to_i)
        puts "There is not empty space in column #{column_no + 1}"
        false
      else
        true
      end
    end

    def is_number?(string)
      true if Float(string)
    rescue StandardError
      false
    end
  end
end
