class BoardController < ApplicationController
  
  def take_turn
    #assume that this is only against an A.I. and that if this method
    # is invoked, it is because a human told it to.    
    @board = Board.find(params[:id])
    
    @board.make_move(params[:x], params[:y], Board::HUMAN)

    
    if @board.has_available_moves?
      
    end
  end
  
end