class BoardController < ApplicationController
  
  def take_turn
    #assume that this is only against an A.I. and that if this method
    # is invoked, it is because a human told it to.    
    @board = Board.find(params[:id])
    
    @x = params[:x].to_i
    @y = params[:y].to_i
    @player = Board::HUMAN
    
    @board.make_move(@x, @y, @player)

    @x_ai = nil
    @y_ai = nil
    if @board.has_available_moves?
      ai_move = @board.make_ai_make_a_move
      
      @x_ai = ai_move[0]
      @y_ai = ai_move[1]
    end
   
   @board.save
   render 'refresh_board.js.erb', :layout => false

  end
  
end