require 'test_helper'

class BoardTest < ActiveSupport::TestCase

  def setup
    @board = Board.new
    @board.init
    @board.save
  end
 

   ##################################
   #  Testing has_this_player_won?  #
   ##################################
   
    test "the ability to win in the right column" do 
      @board.state = [nil,nil,1,nil,nil,1,nil,nil,1]
      assert @board.has_this_player_won?(1)
    end

    test "the ability to win in the right column for the wrong player" do 
      @board.state = [nil,nil,1,nil,nil,1,nil,nil,1]
      assert !@board.has_this_player_won?(0)
    end  
    
    test "if the column winning is right 2" do
      @board.state = [1,nil,nil,1,nil,nil,1,nil,nil]
      assert @board.has_this_player_won?(1)
    end
    
    test "if the column winning is right 2 for the wrong player" do
      @board.state = [1,nil,nil,1,nil,nil,1,nil,nil]
      assert !@board.has_this_player_won?(0)
    end
    
    test "if the row winning is right" do 
      @board.state = [1,1,1,nil,nil,nil,nil,nil,nil]
      assert @board.has_this_player_won?(1)
    end

    test "if the row winning returns false for the wrong player" do 
      @board.state = [1,1,1,nil,nil,nil,nil,nil,nil]
      assert !@board.has_this_player_won?(0)
    end
    
    test "if we dont return true for incomplete cols" do 
      @board.state = [1,nil,nil,1,nil,nil,nil,nil,nil]
      assert !@board.has_this_player_won?(1)
    end
  
    test "if we dont return true for incomplete rows" do 
      @board.state = [1,nil,1,nil,nil,nil,nil,nil,nil]
      assert !@board.has_this_player_won?(1)
    end
  
    test "if we return true for complete diag" do 
      @board.state = [1,nil,1,nil,1,nil,nil,nil,1]
      assert@board.has_this_player_won?(1)
    end
    
    test "if we return false for complete diag but for the wrong player" do 
      @board.state = [1,nil,1,nil,1,nil,nil,nil,1]
      assert !@board.has_this_player_won?(0)
    end
    
    test "if we return payer for complete diag with two players" do 
      @board.state = [1,0,1,0,1,nil,nil,0,1]
      assert @board.has_this_player_won?(1)
    end

    test "if we return false for complete diag with two players for the wrong player" do 
      @board.state = [1,0,1,0,1,nil,nil,0,1]
      assert !@board.has_this_player_won?(0)
    end

    test "if we return player for complete row with two players" do 
      @board.state = [0,0,0,0,1,nil,nil,0,1]
      assert @board.has_this_player_won?(0)
    end

    test "if we return player for complete col with two players" do 
      @board.state = [0,1,0,0,nil,1,0,0,1]
      assert @board.has_this_player_won?(0)
    end      
    
   ###############################
   #  Test has_available_moves?  #
   ###############################    
    
    test "return true for a remaining nil space" do 
      @board.state = [0,1,0,0,nil,1,0,0,1]
      assert @board.has_available_moves?
    end
    
    test "return true for multiple remaining nil space" do 
      @board.state = [nil,1,0,0,nil,1,nil,0,1]
      assert @board.has_available_moves?
    end     
    
    test "return false for no remaining nil space" do 
      @board.state = [0,1,0,0,1,1,0,0,1]
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
     assert_equal(Board::HUMAN, @board.board_state[0])  
   end
   
   test "can make valid move in the last row" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     @board.make_move(2,2,Board::HUMAN)
     assert_equal(Board::HUMAN, @board.board_state[8])  
   end
   
   #############################
   # test make_move_with_index #
   #############################
   test "making a move with a valid index, rather than x,y coords min" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     @board.make_move_with_index(0, 1)
     assert_equal(1, @board.board_state[0])
   end
   
   test "making a move with a valid index, rather than x,y coords max" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     @board.make_move_with_index(8, 1)
     assert_equal(1, @board.board_state[8])
   end
   
   ##################
   # test undo_move #
   ##################
   
   
   ##########################
   # Test state_of_location #
   ##########################
   test "if the returning of the state of a spot on the grid is correct for nil" do
     @board.state = [nil,nil,nil,1,0,1,nil,nil,nil]
     assert_equal(nil, @board.state_of_location(0,0))
   end 

   test "if the returning of the state of a spot on the grid is correct for 1" do
     @board.state = [nil,nil,nil,1,0,1,nil,nil,nil]
     assert_equal(1, @board.state_of_location(0,1))
   end 
   
   ########################
   # Test remaining_moves #
   ########################
   test "if remaining_moves / spaces are calculated correctly" do
     @board.state = [1,0,nil,1,1,1,0,0,0]
     assert_equal([2], @board.remaining_moves)
   end
   
   test "if remaining_moves / spaces are calculated correctly for no moves used" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     assert_equal([0,1,2,3,4,5,6,7,8], @board.remaining_moves)
   end
   
   test "if remaining_moves / spaces are calculated correctly for all moves used" do
     @board.state = [1,0,1,0,1,0,1,0,1]
     assert_equal([], @board.remaining_moves)
   end
   
   
   #############
   # Test A.I. #
   #############
   # computer is 0, human is 1
   # c h c
   # _ h h
   # _ c h -- computer's turn
   test "make sure alpha-beta pruning works (human went first) 1" do
     @board.state = [0,1,0,nil,1,1,nil,0,1]
     score = @board.alphabeta(0, 0, Board::COMPUTER)
     assert_equal(Board::DRAW, score)
     
   end
   
   # computer is 0, human is 1
   # _ _ h
   # h c c
   # h c h -- computer's turn
   test "make sure the alpha-beta pruning works (human went first) 2" do
     @board.state = [nil,nil,1,1,0,0,1,0,1]
     score = @board.alphabeta(0,0,Board::COMPUTER)
     assert_equal(Board::WIN, score)
   end
   
   test "make sure that the A.I. doesn't return nil" do
     @board.state = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
     assert_not_nil(@board.calculate_ai_next_move)
   end
      
  def teardown

  end
end
