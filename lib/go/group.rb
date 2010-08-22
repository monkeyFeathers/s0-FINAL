module Go
  class Group
    attr_accessor :liberties, :stones, :color, :territory
  
    def initialize(*stones)
      @stones = []
      @liberties = []
      if stones.empty?
        raise ArgumentError, "need at least one stone to have a group"
      end
      unless stones.length == 0
        stones.each {|s| add s}
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
      @liberties == 1
    end
    
    def captured
      @stones.each do |stone|
        stone.captured
      end
      @captured = true
    end
    
  end
end