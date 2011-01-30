require 'test_helper'

class BoardTest < ActiveSupport::TestCase

  def setup
    @board = Board.new
    @board.init
  end
  # 
  # test "if the column winning is right 1" do 
  #   @board.state = [0,0,1,0,0,1,0,0,1]
  #   assert @board.does_a_winner_exist?
  # end
  # 
  # test "if the column winning is right 2" do
  #   @board.state = [1,0,0,1,0,0,1,0,0]
  #   assert @board.does_a_winner_exist?
  # end
  # 
  # test "if the row winning is right" do 
  #   @board.state = [1,1,1,0,0,0,0,0,0]
  #   assert @board.does_a_winner_exist?
  # end
  # 
  
  
  
  
  
  test "if we dont return true for incomplete cols" do 
    @board.disp_s

    @board.state = [1,0,0,1,0,0,0,0,0]
    @board.disp_s

    #puts @board.does_a_winner_exist?
    assert !@board.does_a_winner_exist?
  end
  
  def teardown

s  end
end
