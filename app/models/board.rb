class Board < ActiveRecord::Base
  WIDTH = 3
  NUM_SQUARES = WIDTH * WIDTH
  COMPUTER = 1
  HUMAN = 2
  
  @board_layout = []
  
  WINNING_ROWS = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
  WINNING_COLS = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
  WINNING_DIAG = [[0, 4, 8], [2, 4, 6]]
    
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
    #     WINNING_ROWS << (row_start..row_start - 1 + WIDTH).to_a
    #     WINNING_COLS << (row..NUM_SQUARES - 1).step(WIDTH).to_a
    #   end
    #     
    #   WINNING_DIAG << (0..NUM_SQUARES).step(WIDTH + 1).to_a
    #   WINNING_DIAG << (WIDTH - 1..NUM_SQUARES - WIDTH + 1).step(WIDTH - 1).to_a
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
  
  def number_of_squares
     self.width * self.width
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
 
 # following the min-max algorithm from wikipedia
 # http://en.wikipedia.org/wiki/Alpha-beta_pruning
 # and 
 # http://en.wikipedia.org/wiki/Negamax
 def make_ai_make_a_move
   @remaining_moves = self.state.each_with_index.map{|e,i| (e.nil?) ? nil : i }.compact
   #self.state.each_with_index do |item, index|
   #  @remaining_moves << index unless item.nil?
   #end
   
   # super slick, but only available in ruby 1.9
   #state.map.with_index { |e, i| (e.nil?) ? nil : i }.compact
   move_rank = -10
   best_move = -1
   
   sim_player = COMPUTER
   
   @remaining_moves.each do |available_move|
     self.make_move_with_index(available_move, sim_player)
     @remaining_moves.delete(available_move)
     sim_player = switch_player(sim_player)
     move_val = -negamax(sim_player)
     self.undo_move(available_move)
     @remaining_moves << available_move

     if move_rank < move_val
       move_rank = move_val
       best_move = available_move
     end
   end
   return best_move
  end
   
 def negamax(sim_player)
   winner = self.does_a_winner_exist?
   return 1 if winner == sim_player
   return -1 if winner == switch_player(sim_player)
   
   best_score = -255
   
   @remaining_moves.each do |available_move|
     self.make_move_with_index(available_move, sim_player)
     @remaining_moves.delete(available_move)
     value = -negamax(switch_player(sim_player))
     self.undo_move(available_move)
     @remaining_moves << available_move

     best_score = value if value > best_score
   end
   
   return best_score == -255 ? 0 : best_score
 end
 
 def simulate_move(index, player)
   @sim_state[index] = player
   @sim_remaining_moves = @sim_remaining_moves - index
    
 end
  
 def switch_player(player)
   player == COMPUTER ? HUMAN : COMPUTER
 end
  
  
  #check horizontally, then vertically, then diagonally
  # returns the player if there is a winner.
  # false otherwise
  def does_a_winner_exist?(state = self.state)
    result = false
    WINNING_ROWS.each { |row| result = state[row[0]] if contains_win?(row) }
    WINNING_COLS.each { |col| result = state[col[0]] if contains_win?(col) }
    WINNING_DIAG.each { |diag| result = state[diag[0]] if contains_win?(diag)}
    return result
  end
  
  def contains_win?(ttt_win_state)
    ttt_win_state.each do |pos|
      return false if self.state[pos] != self.state[ttt_win_state[0]] or self.state[pos].nil?
    end
    
    return true
  end
  
  def check_end_of_game
    tie = self.has_available_moves?
    return (tie or self.does_a_winner_exist?)
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
