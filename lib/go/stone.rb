module Go
  class Stone
    attr_accessor :point, :color, :captured, :in_group, :group
    attr_writer :liberties
  
    def initialize(color, point, *liberties)
      @point = point
      @liberties = liberties.flatten
      unless color == :black or color == :white
        raise ArgumentError, "Improper stone value: #{stone}; Stones must be :black or :white"
      else
        @color = color
      end
      @captured = false
      @in_group = false
    end
  
    def can_breathe?
      @liberties.length >= 1
    end
    
    def liberties
      check_liberties
      @liberties
    end
    
    def check_liberties
      liberties = []
      @liberties.each do |liberty|
        if liberty.empty?
          liberties << liberty
        elsif liberty.stone.color == @color
          @in_group = true
        end
      end
      @liberties = liberties
    end
    
    def captured?
      unless @captured == true
        check_liberties
        if @liberties.length == 0 and !in_group?
          captured
          @point.empty
        elsif in_group?
          raise JustASoldierError, "I don't know about the whole group"
        end
      end
      @captured
    end
    
    def captured
      @captured = true
    end
    
    def in_group?
      check_liberties
      !!@in_group
    end
    
    def in_atari?
      check_liberties
      if @liberties.length == 1 and !in_group?
        true
      elsif in_group?
        raise JustASoldierError, "I don't know about the whole group"
      else
        false
      end
    end
    
    def occupy
      @point.stone = self
    end
    
  end
end