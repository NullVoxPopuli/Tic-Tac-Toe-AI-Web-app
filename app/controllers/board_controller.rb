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

            ai_move = @board.calculate_ai_next_move
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


        # this check is to prevent clicking on a space that has
        # already been taken due to some sort of delay in the 
        # server's response
        unless @board.square_is_already_taken?(@x, @y)
            @board.make_move(@x, @y, @player)
            end_game = @board.check_end_of_game

            if not @board.has_this_player_won?(Board::HUMAN)
                @x_ai = nil
                @y_ai = nil
                if @board.has_available_moves?
                    time1 = Time.new
                    ai_move = @board.calculate_ai_next_move
                    puts "====================="
                    puts "A.I. took this long (seconds) to decide where to move: " + (Time.new - time1).inspect

                    @x_ai = ai_move % Board::WIDTH
                    @y_ai = (ai_move - @x_ai) / Board::WIDTH

                    @board.make_move(@x_ai, @y_ai, Board::COMPUTER)

                    if @board.has_this_player_won?(Board::COMPUTER)
                        display_win(Board::COMPUTER)
                    return
                    end
                else
                    display_tie
                return
                end

            else
            # do something with the game ending
                display_win(Board::HUMAN)
            return
            end

            @board.save
            render 'refresh_board.js.erb', :layout => false

        end

    end

    def display_win(player)
        @game_over_state_message = "Winner: "
        @outcome_message = (player == Board::COMPUTER ? "Computer" : "Human")
        render "game_over.js.erb", :layout => false
    end

    def display_tie
        @game_over_state_message = ""
        @outcome_message = "No Winner"
        render "game_over.js.erb", :layout => false
    end
end
