module Go
  class Point
    
    attr_accessor :ko
    attr_reader :stone, :position, :x, :y
    
    def initialize(x,y)
      @position = [x,y]
      @x,@y = @position[0],@position[1]
      @ko = false
    end
    
    
    def stone=(stone)
      if @stone
        raise Go::MoveError, "Point at #{@x}, #{@y} already occupied by #{@stone.to_s}."
      end
      unless stone.class == Go::Stone
        raise ArgumentError, "Can only place Go::Stones in Go::Points"
      end
      @stone = stone
    end
    
    def empty
      @stone = nil
    end
    
    def empty?
      if @stone == nil
        true
      else
        false
      end
    end
    
    def ko?
      !!@ko
    end
    
  end
end