class BoardController < ApplicationController
  
  def take_turn
    #assume that this is only against an A.I. and that if this method
    # is invoked, it is because a human told it to.    
    @board = Board.find(params[:id])
    
    @x = params[:x].to_i
    @y = params[:y].to_i
    @player = Board::HUMAN
    
    @board.make_move(@x, @y, @player)

    
    if @board.has_available_moves?
      @board.make_ai_make_a_move
         
      render 'refresh_board.js.erb', :layout => false
    else
      render 'winner.js.erb', :layout => false
    end
    
  end
  
end