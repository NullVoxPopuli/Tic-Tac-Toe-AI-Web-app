class Board < ActiveRecord::Base
  
  WIDTH = 3
  NUM_SQUARES = WIDTH * WIDTH
  @@computer_player = 1
  @@human_player = 2
  
  WINNING_ROWS = []
  WINNING_COLS = []
  WINNING_DIAG = []
  
  @board_layout = []
    
  def init
    @board_layout = Array.new(NUM_SQUARES)
    
    #generate the ways to win
    WIDTH.times do |row|
    
      row_start = row * WIDTH
      
      WINNING_ROWS << (row_start..row_start - 1 + WIDTH).to_a
      WINNING_COLS << (row..NUM_SQUARES).step(WIDTH).to_a
    end
    
     WINNING_DIAG << (0..NUM_SQUARES).step(WIDTH + 1).to_a
     WINNING_DIAG << (WIDTH - 1..NUM_SQUARES).step(WIDTH - 1).to_a
      
  end
  
  def board_state
    @board_layout
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
  
  #check horizontally, then vertically, then diagonally
  # returns player_one or player_two if there is a winner.
  # false otherwise
  def does_a_winner_exist?
    WINNING_ROWS.each { |row| return @board_layout[row[0]] if contains_win?(row) }
    WINNING_COLS.each { |col| return @board_layout[col[0]] if contains_win?(col) }
    WINNING_DIAG.each { |diag| return @board_layout[diag[0]] if contains_win?(diag)}
  end
  
  def contains_win?(ttt_data)
    ttt_data.each do |pos|
      return false if @board_layout[pos] != @board_layout[pos[0]] or @board_layout[pos].nil?
    end
    
    return true
  end
  
  def disp_s
    puts "Layout:"
    WIDTH.times do |row|
      WIDTH.times do |col|
        print @board_layout[col * row + col]
      end
      puts " "
    end
    
    puts " "
  end

end
