class BoardController < ApplicationController
  
  
    def start_game
      @human_is_going_first = params[:human_is_first]
      @board = Board.new
      @board.init
      @board.save
      
      puts params[:human_is_first]
      puts (not @human_is_going_first)
      if not @human_is_going_first 
        time1 = Time.new

        ai_move = @board.make_ai_make_a_move
 puts "====================="
        puts "A.I. took this long (seconds) to decide where to move: " + (Time.new - time1).inspect
        
        @x_ai = ai_move % Board::WIDTH
        @y_ai = (ai_move - @x_ai) / Board::WIDTH
        
        @board.make_move(@x_ai, @y_ai, Board::COMPUTER)
        @board.save
      end
      
      render 'start_game.js.erb', :layout => false
    end
  
  def take_turn
    #assume that this is only against an A.I. and that if this method
    # is invoked, it is because a human told it to.    
    @board = Board.find(params[:id])
    
    @x = params[:x].to_i
    @y = params[:y].to_i
    @player = Board::HUMAN
    
    @board.make_move(@x, @y, @player)
    end_game = @board.check_end_of_game
    
    #if end_game != Board::HUMAN
      @x_ai = nil
      @y_ai = nil
      if @board.has_available_moves?
        time1 = Time.new
        ai_move = @board.make_ai_make_a_move
        puts "====================="
        puts "A.I. took this long (seconds) to decide where to move: " + (Time.new - time1).inspect
        
        @x_ai = ai_move % Board::WIDTH
        @y_ai = (ai_move - @x_ai) / Board::WIDTH
        
        @board.make_move(@x_ai, @y_ai, Board::COMPUTER)
        
      end
    #else
      # do something with the game ending
    #end
   
   @board.save
   render 'refresh_board.js.erb', :layout => false

  end
  
end