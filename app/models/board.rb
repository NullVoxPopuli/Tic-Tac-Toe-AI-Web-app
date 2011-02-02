class Board < ActiveRecord::Base
    WIDTH = 3
    NUM_SQUARES = WIDTH * WIDTH
    COMPUTER = 0
    HUMAN = 1

    @board_layout = []

    WAYS_TO_WIN = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],[0, 4, 8], [2, 4, 6]]

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
        return self.state.include? nil
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

    def remaining_moves
        self.state.each_with_index.map{|e,i| (e.nil?) ? i : nil }.compact
    end

    #based off http://www.webkinesia.com/games/gametree.php
    # (converted from C++ code from the alpha - beta pruning section)

    WIN = 1
    LOSS = -1
    DRAW = 0
    INFINITY = 100
    @cur_player = COMPUTER

    def calculate_ai_next_move
        best_move = -1
        best_score = -10
        
            @cur_player = COMPUTER

        self.remaining_moves.each do |move|
          self.make_move_with_index(move, @cur_player)
          score = -self.alphabeta(-INFINITY,INFINITY, 1 - @cur_player)
          self.undo_move(move)
          
          if score > best_score
            best_score = score
            best_move = move
          end
        end
       
        return best_move
    end
    
    def alphabeta(alpha, beta, player)
      best_score = -INFINITY
      if not self.has_available_moves?
        return DRAW
      elsif self.has_this_player_won?(player) == player
        return WIN
      elsif self.has_this_player_won?(1 - player) == 1 - player
        return LOSS
      else
        self.remaining_moves.each do |move|
          break if alpha > beta
          
          self.make_move_with_index(move, player)
          move_score = -alphabeta(-beta, -alpha, 1 - player)
          self.undo_move(move)
          
          if move_score > alpha
            alpha = move_score
            next_move = move
          end
          best_score = alpha
        end
      end
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


    def disp_me
        puts "Layout:"
        WIDTH.times do |row|
            WIDTH.times do |col|
                print self.state[WIDTH * row + col]
            end
            puts " "
        end
        puts " "
        puts " Solutions: "
        puts WINNING_ROWS.inspect
        puts WINNING_COLS.inspect
        puts WINNING_DIAG.inspect
    end

end
