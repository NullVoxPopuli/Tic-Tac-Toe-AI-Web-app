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
    
    return self.does_a_winner_exist?
 end
 
 #following the min-max algorithm from wikipedio
 def make_ai_make_a_move
   state = self.state
   move_rank = -10
   best_move = -1
   
   
   
   # result = make_move(0,0,COMPUTER) 
   # if false != result
   #   return result
   # end
   # 
   # return [0,0]
 end
  
  
  
  #check horizontally, then vertically, then diagonally
  # returns the player if there is a winner.
  # false otherwise
  def does_a_winner_exist?
    result = false
    WINNING_ROWS.each { |row| result = self.state[row[0]] if contains_win?(row) }
    WINNING_COLS.each { |col| result = self.state[col[0]] if contains_win?(col) }
    WINNING_DIAG.each { |diag| result = self.state[diag[0]] if contains_win?(diag)}
    return result
  end
  
  def contains_win?(ttt_win_state)
    ttt_win_state.each do |pos|
      return false if self.state[pos] != self.state[ttt_win_state[0]] or self.state[pos].nil?
    end
    
    return true
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
