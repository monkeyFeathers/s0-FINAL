module Go
  class Point
    
    attr_reader :stone, :position
    
    def initialize(x,y)
      @position = [x,y]
    end
    
    
    def stone=(stone)
      if @stone
        raise Go::MoveError, "Point at #{@position[0]},#{@position[1]}  already occupied by #{@stone.to_s}."
      end
      unless stone == :black or stone == :white
        raise ArgumentError, "Improper stone value: #{stone}; Stones must be :black or :white"
      else
        @stone = stone
      end
    end
    
    def empty
      @stone = nil
    end
    
    def empty?
      !@stone
    end
    
  end
end