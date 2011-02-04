class Board < ActiveRecord::Base
    WIDTH = 3
    NUM_SQUARES = WIDTH * WIDTH
    COMPUTER = 0
    HUMAN = 1

    @board_layout = []

    # 0 1 2
    # 3 4 5
    # 6 7 8
    WAYS_TO_WIN = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    serialize :state

    def init
        self.state = Array.new(NUM_SQUARES) if not self.state

    #generate the ways to win
    # commented out, because even though this would stored in static variables,
    # the values did not persist in different instances of board
    # if WINNING_ROWS.length < 2 #don't re-compute
    #   WIDTH.times do |row|
    #
    #   row_start = row * WIDTH
    #
    #     WAYS_TO_WIN << (row_start..row_start - 1 + WIDTH).to_a
    #     WAYS_TO_WIN << (row..NUM_SQUARES - 1).step(WIDTH).to_a
    #   end
    #
    #   WAYS_TO_WIN << (0..NUM_SQUARES).step(WIDTH + 1).to_a
    #   WAYS_TO_WIN << (WIDTH - 1..NUM_SQUARES - WIDTH + 1).step(WIDTH - 1).to_a
    # end
    end

    def square_is_already_taken?(x, y)
        not self.state_of_location(x, y).nil?
    end

    def board_state
        self.state
    end

    def state_of_location(x, y)
        self.state[WIDTH * y + x]
    end

    def set_square(x, y, val)
        self.state[WIDTH * y + x] = val
    end

    def width
        WIDTH
    end

    def has_available_moves?
        self.state.include? nil
    end

    def make_move(x, y, player)
        self.set_square(x,y, player)
    end

    def make_move_with_index(index, player)
        self.state[index] = player
    end

    def undo_move(index)
        self.state[index] = nil
    end
  
    def empty?
      self.state.count(nil) == NUM_SQUARES
    end

    def remaining_moves
        self.state.each_with_index.map{|e,i| (e.nil?) ? i : nil }.compact
    end

    #based off http://www.webkinesia.com/games/gametree.php
    # (converted from C++ code from the alpha - beta pruning section)

    WIN = 1
    LOSS = -1
    DRAW = 0
    INFINITY = 10000
    @cur_player = COMPUTER
    BEST_FIRST_MOVES = [0, 2, 8, 6] #teh corners

    def calculate_ai_next_move
        if self.empty? #this is assuming the A.I. is going first.
          #first move doesn't matter, as long as it's a corner
          return BEST_FIRST_MOVES[rand(3)]
        end
        
        best_move = -1
        best_score = -5

        @cur_player = COMPUTER

        self.remaining_moves.each do |move|
            self.make_move_with_index(move, @cur_player)
            score = -self.alphabeta_negamax(-INFINITY,INFINITY, 1 - @cur_player)
            self.undo_move(move)

            if score > best_score
            best_score = score
            best_move = move
            end
        end

        return best_move
    end

    def alphabeta_negamax(alpha, beta, player)
        winner = self.check_end_of_game
        return WIN if winner == player
        return LOSS if winner == 1 - player

        best_score = -INFINITY

        self.remaining_moves.each do |move|
            break if alpha > beta

            self.make_move_with_index(move, player)
            move_score = -alphabeta_negamax(-beta, -alpha, 1 - player)
            self.undo_move(move)

            if move_score > alpha
            alpha = move_score
            end
            best_score = alpha
        end

        return 0 if best_score == -INFINITY
        return best_score
    end

    def has_this_player_won?(player)
        WAYS_TO_WIN.each do |way_to_win|
            return true if self.state.values_at(*way_to_win).uniq.size == 1 and self.state[way_to_win[0]] == player
        end

        return false
    end

    # returns false if the game is not over, or if there is a tie
    def check_end_of_game
        return has_this_player_won?(COMPUTER) ? COMPUTER : (has_this_player_won?(HUMAN) ? HUMAN : false)
    end

    def to_s
        result = ""
        WIDTH.times do |row|
            WIDTH.times do |col|
                result += self.state[WIDTH * row + col].inspect + " "
            end
            result += "\n"
        end  
        return result      
    end
    
end
