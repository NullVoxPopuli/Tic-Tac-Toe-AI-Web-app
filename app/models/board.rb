class Board < ActiveRecord::Base
  
  WIDTH = 3
  NUM_SQUARES = WIDTH * WIDTH
  COMPUTER = 1
  HUMAN = 2
  
  WINNING_ROWS = []
  WINNING_COLS = []
  WINNING_DIAG = []
  
  @board_layout = []
    
  def init  
    @board_layout = Array.new(NUM_SQUARES)
    
    #generate the ways to win
    if WINNING_ROWS.length < 1#don't re-compute
      WIDTH.times do |row|
      
        row_start = row * WIDTH
        
        WINNING_ROWS << (row_start..row_start - 1 + WIDTH).to_a
        WINNING_COLS << (row..NUM_SQUARES - 1).step(WIDTH).to_a
      end
      
       WINNING_DIAG << (0..NUM_SQUARES).step(WIDTH + 1).to_a
       WINNING_DIAG << (WIDTH - 1..NUM_SQUARES - WIDTH + 1).step(WIDTH - 1).to_a
     end
  end
  
  def board_state
    @board_layout
  end
  
  def state_of_location(x, y)
    @board_layout[WIDTH * y + x]
  end
  
  def state=(custom_board)
    @board_layout = custom_board
  end
  
  def set_square(x, y, val)
    @board_layout[self.width * y + x] = val
  end
  
  def width
    WIDTH
  end
  
  def number_of_squares
     self.width * self.width
  end
  
 def has_available_moves?
   return @board_layout.include? nil
 end
 
 def make_move(x, y, player)
    self.set_square(x,y, player)
 end
 
 def make_ai_make_a_move
   
 end
  
  #check horizontally, then vertically, then diagonally
  # returns the player if there is a winner.
  # false otherwise
  def does_a_winner_exist?
    result = false
    WINNING_ROWS.each { |row| result = @board_layout[row[0]] if contains_win?(row) }
    WINNING_COLS.each { |col| result = @board_layout[col[0]] if contains_win?(col) }
    WINNING_DIAG.each { |diag| result = @board_layout[diag[0]] if contains_win?(diag)}
    return result
  end
  
  def contains_win?(ttt_win_state)
    ttt_win_state.each do |pos|
      return false if @board_layout[pos] != @board_layout[ttt_win_state[0]] or @board_layout[pos].nil?
    end
    
    return true
  end
  
  def disp_me
    puts "Layout:"
    WIDTH.times do |row|
      WIDTH.times do |col|
        print @board_layout[WIDTH * row + col]
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