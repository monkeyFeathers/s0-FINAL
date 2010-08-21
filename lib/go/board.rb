module Go
  
  class BoardError < StandardError
  end
  
  class MoveError < StandardError
  end
  
  class Board
    
    attr_accessor :stones, :occupied_points, :points, :chains
    
    def initialize(*dimensions)
      # ensure proper dimensions for game
      case dimensions.length
      when 0
        build_grid 9,9
      when 1
        l = dimensions.first
        w = l
        build_grid l, w
      when 2
        unless dimensions.first == dimensions.last
          raise Go::BoardError, "Go is played on a square but you want to play on a #{dimensions.first}, #{dimensions.last} board?"
        else
          unless dimensions.first == 9 or dimensions.first == 13 or dimensions.first == 19
            warn "Go usually played on 9x9, 13x13, or 19x19 board"
          end 
          build_grid dimensions.first, dimensions.first
        end
      end
      @stones = []
      @occupied_points = []
      @chains = []
    end
    
    def place_stone(stone, *position)
      ###################################################################################
      #check if move is valid
      position = position.flatten
      # check that position is valid
      # ensure both x and y coordinates
      unless position.length == 2
        raise ArgumentError, "require x,y to place stone"
      end
      # make sure position is on the board
      [position.first, position.last].each do |v|
        unless v > 0 and v < @dimensions
          raise Go::MoveError, "You tried to place a stone outside of the board dimensions of #{@dimensions},#{@dimensions}"
        end
      end
      
      # find point at position indicated and place stone there
      move = ""
      @points.each do |point|
        if point.position == position
          point.stone = stone
          
          # put into stones array
          @stones << point
          move = point
        end
      end
      
      ###############################################################################
      # check liberties for placed stone
      
    end
    
    def build_grid(l, w)
      @dimensions = l
      @points ||= []
      il = 1
      l.times do
        iw = 1
        w.times do
          if p = Go::Point.new(il,iw)
            @points << p
          end 
          iw = iw + 1
        end
        il = il + 1
      end
    end
    
    def liberties(point)
      liberties = []
      x,y = point.position[0],point.position[1]

      # collect adjacent points
      adjacent_points = []
      [[x+1,y],[x-1,y],[x,y+1],[x,y-1]].each do |c|
        @points.each do |p|
          if p.position == c
            adjacent_points << p
          end
        end
      end
      
      # check if adjacent points are empty
      # if empty add to stones liberties
      # if occupied by same color add to chain with liberties
      
      adjacent_points.each do |p|
        if p.empty?
          
        end
      end
      
    end
    
  end # board
  
  class Stone
    attr_accessor :liberties, :point, :color
    
    def initialize(point,liberties, color)
      @point = point
      @liberties = liberties
      @color = color
    end
    
  end
  
  class Chain
    attr_accessor :liberties, :points, :color
    
    def initialize(points, liberties)
      @points = []
      @liberties = []
      @points << point
      @liberties << liberties
      @color = color
    end
    
  end
  
end # go