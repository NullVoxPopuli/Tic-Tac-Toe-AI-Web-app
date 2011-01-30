class ApplicationController < ActionController::Base
    protect_from_forgery
    def index
        # ask whether teh player wants to go first or second

    end

    def start_game
      @human_is_going_first = params[:human_is_first]
      @board = Board.new
      @board.init
      @board.save
      
      if not @human_is_going_first
        @board.make_ai_make_a_move
      end
      
      if request.xhr?
          render 'start_game.js.erb', :layout => false
      end
    end

end
