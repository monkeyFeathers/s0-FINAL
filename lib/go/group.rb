module Go
  class Group
    attr_accessor :stones, :color, :territory, :captured
    attr_writer :liberties
  
    def initialize(*stones)
      @captured = false
      @stones = []
      @liberties = []
      if stones.empty?
        raise ArgumentError, "need at least one stone to have a group"
      end
      unless stones.length == 0
        stones.flatten.each do |s|
         if s.class == Go::Stone
            add s
          else
            raise Go::MoveError, "only stones and not #{s} can be placed in groups"
          end
        end
      end
    end
  
    def add(stone)
      @stones << stone
      liberties = []
      stone.liberties.each do |liberty|
        liberties << liberty
      end
      stone.group = self
      @liberties = liberties.flatten
    end
    
    def in_atari?
      liberties
      @liberties.length == 1
    end
    
    def captured
      @stones.each do |stone|
        stone.captured
      end
      @captured = true
    end
    
    def liberties
      liberties = []
      @stones.each do |stone|
        begin
          stone.occupy
        rescue Go::MoveError
          next
        end
      end
      @stones.each do |stone|
        stone.liberties.each do |l|
          if l.empty?
            liberties << l
          end
        end
      end
      @liberties = liberties
    end
    
  end
end