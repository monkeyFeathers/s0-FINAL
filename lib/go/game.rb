module Go
  
  class Game
    
    attr_accessor :board, :white, :black, :players, :moves, :game_over
    
    def initialize(dimensions=[])
      @board = Go::Board.new
      @white = false
      @black = true
      @moves = []
      @players = [@black, @white]
      @game_over = false
    end
    
    def move(player,*move)
      string = "p = @#{player.to_s}"
      color = player
      p = ""
      eval string
      puts p
      unless game_over?
        puts player
        if player
          move.flatten!
          # check for pass and handle
          if move.length == 1 and move.first == :pass
            player = :pass
          else
            @board.place_stone(color, args)
          end
        else
          raise Go::MoveError, "wrong turn"
        end
      else
        raise Go::GameOverError, "Game over"
      end
      next_turn
    end
    
    def next_turn
      pass = false
      @players.each do |player|
        case player
        when true
          player = false
        when false
          player = true
        when :pass
          unless pass 
            pass = true
          else
            game_over
            puts "game over"
          end
        end
      end
    end
    
    def method_missing(id,*args)
      if id.to_s =~ /_move\z/
        id = id.to_s.split("_")
        pre, suf = id.first, id.last
        if pre == "black" or pre == "white"
          args.unshift(pre.to_sym)
          send(suf.to_sym,args)
        end
      else 
        super
      end 
    end
    
    def game_over?
      @game_over
    end
    
    def game_over
      @game_over = true
    end
    
  end

end