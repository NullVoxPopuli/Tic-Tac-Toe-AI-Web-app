require 'test_helper'

class BoardTest < ActiveSupport::TestCase

  def setup
    @board = Board.new
    @board.init
    @board.save
  end
  
  # test "the initial set up of the winning rows in the board with width 3" do
  #   assert_equal(Board::WINNING_ROWS, [[0, 1, 2], [3, 4, 5], [6, 7, 8]])
  # end
  # 
  # test "the initial set up of the winning cols in the board with width 3" do
  #   assert_equal(Board::WINNING_COLS, [[0, 3, 6], [1, 4, 7], [2, 5, 8]])
  # end
  # 
  # test "the initial set up of the winning diags in the board with width 3" do
  #   assert_equal(Board::WINNING_DIAG, [[0, 4, 8], [2, 4, 6]])
  # end
    
   ###########################
   #  Testing contains_win?  #
   ###########################

    test "the ability to check if the section of the board has a win on a row" do
      @board.state = [nil, nil, nil, 1, 1, 1, nil, nil, nil]
      assert @board.contains_win?([3,4,5])
    end
    
    test "the ability to check if the section of the board has a win on a col" do
      @board.state = [1, nil, nil, 1, nil, nil, 1, nil, nil]
      assert @board.contains_win?([0,3,6])
    end
    
    test "the ability to check if the section of the board has a win on a diag" do
      @board.state = [1, nil, nil, nil, 1, nil, nil, nil, 1]
      assert @board.contains_win?([0,4,8])
    end
    
    test "if it returns false with multiple players (down first col)" do
      @board.state = [1,1,2,2,nil,2,nil,nil,1]
      assert !@board.contains_win?([0,4,8])
    end
 
    test "if it returns false with multiple players (accross first row)" do
      @board.state = [1,1,2,2,nil,2,nil,nil,1]
      assert !@board.contains_win?([0,1,2])
    end 

    test "if it returns false with multiple players (down first diag)" do
      @board.state = [1,1,2,2,nil,2,nil,nil,1]
      assert !@board.contains_win?([0,4,8])
    end 

    test "if it returns true with multiple players (down first diag)" do
      @board.state = [2,1,1,1,2,nil,2,1,2]
      assert @board.contains_win?([0,4,8])
    end 

    test "if it returns true with multiple players (accross first row)" do
      @board.state = [2,2,2,1,2,1,2,1,2]
      assert @board.contains_win?([0,1,2])
    end 
  
   ##################################
   #  Testing does_a_winner_exist?  #
   ##################################
   
    test "the ability to win in the right column" do 
      @board.state = [nil,nil,1,nil,nil,1,nil,nil,1]
      assert_equal(1, @board.does_a_winner_exist?)
    end
  
    
    test "if the column winning is right 2" do
      @board.state = [1,nil,nil,1,nil,nil,1,nil,nil]
      assert_equal(1, @board.does_a_winner_exist?)
    end
    
    test "if the row winning is right" do 
      @board.state = [1,1,1,nil,nil,nil,nil,nil,nil]
      assert_equal(1, @board.does_a_winner_exist?)
    end
    
    test "if we dont return true for incomplete cols" do 
      @board.state = [1,nil,nil,1,nil,nil,nil,nil,nil]
      assert !@board.does_a_winner_exist?
    end
  
    test "if we dont return true for incomplete rows" do 
      @board.state = [1,nil,1,nil,nil,nil,nil,nil,nil]
      assert !@board.does_a_winner_exist?
    end
  
    test "if we return player for complete diag" do 
      @board.state = [1,nil,1,nil,1,nil,nil,nil,1]
      assert_equal(1, @board.does_a_winner_exist?)
    end
    
    test "if we return payer for complete diag with two players" do 
      @board.state = [1,2,1,2,1,nil,nil,2,1]
      assert_equal(1, @board.does_a_winner_exist?)
    end

    test "if we return player for complete row with two players" do 
      @board.state = [2,2,2,2,1,nil,nil,2,1]
      assert_equal(2, @board.does_a_winner_exist?)
    end

    test "if we return player for complete col with two players" do 
      @board.state = [2,1,2,2,nil,1,2,2,1]
      assert_equal(2, @board.does_a_winner_exist?)
    end      
    
   ###############################
   #  Test has_available_moves?  #
   ###############################    
    
    test "return true for a remaining nil space" do 
      @board.state = [2,1,2,2,nil,1,2,2,1]
      assert @board.has_available_moves?
    end
    
    test "return true for multiple remaining nil space" do 
      @board.state = [nil,1,2,2,nil,1,nil,2,1]
      assert @board.has_available_moves?
    end     
    
    test "return false for no remaining nil space" do 
      @board.state = [2,1,2,2,1,1,2,2,1]
      assert !@board.has_available_moves?
    end
    
    test "return true for all spaces nil" do 
      @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
      assert @board.has_available_moves?
    end    
    
   ####################
   #  Test make_move  #
   ####################    
   
   # since this method only accepts input from automatically
   # generated links, testing outside the bounds isn't 
   # necissary
   test "can make valid move in the first row" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     @board.make_move(0,0,Board::HUMAN)
     assert_equal(@board.board_state[0], Board::HUMAN)  
   end
   
   test "can make valid move in the last row" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     @board.make_move(2,2,Board::HUMAN)
     assert_equal(@board.board_state[8], Board::HUMAN)  
   end
   
   
  def teardown

  end
end
