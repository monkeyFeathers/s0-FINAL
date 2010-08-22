module Go
  
  class Board
    
    attr_accessor :stones, :occupied_points, :points, :chains, :groups
    
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
      @groups = []
    end
    
    def place_stone(player, *position)
      position = position.flatten
      
      ###################################################################################
      #check if move is exists on board
      
      # check that position is valid with both x and y coordinates
      unless position.length == 2
        raise ArgumentError, "require x,y to place stone"
      end
      
      # make sure position is on the board
      x = position.first
      y = position.last
      [x, y].each do |v|
        unless v > 0 and v < @dimensions
          raise Go::MoveError, "You tried to place a stone outside of the board dimensions of #{@dimensions},#{@dimensions}"
        end
      end
      
      ###############################################################################
      # find point at position indicated and check for liberties and other stones
      point = ""
      liberties = []
      friends = []
      enemies = []
      @points.each do |p|
        if p.position == position
          point = p
          # get liberties and add stone to stone collection
          adjacent_points(point).each do |adjacent_point|
            if adjacent_point.empty?
              liberties << adjacent_point 
            elsif adjacent_point.stone == player
              friends << adjacent_point
            else
              enemies << adjacent_point
            end
          end
        end
      end
        
      # ready stone
      unless point.ko?
        stone = Go::Stone.new(player, point, liberties)
        @points.each {|p| p.ko = false}
      else
        raise Go::MoveError, "Placing a stone at #{@x}, #{y} violates ko"
      end
      
      # add stone to friendly group(s)
      group = ""
      case friends.length
      when 0
        group = Go::Group.new(stone)
      when 1
        group = friends.first.group
        group.stones.push stone
      else
        stones = Array.new
        stones << stone
        friends.each do |friend|
          stones << friend.group.stones
          @groups.delete friend.group
        end
        group = Go::Group.new(stones)
      end
      #check for captures
      captives = []
      if enemies
        enemies.each do |enemy|
          if enemy.stone.group.in_atari?
            if point == enemy.group.liberties.last
              captives << enemy.group
            end
          end
        end
      end
      
      # check for suicide
      if stone.in_atari? or stone.group.in_atari?
        if stone.liberties.last == point or group.liberties.last == point
          unless captives.length > 0
            raise raise Go::MoveError, "No suicides!"
          end
        end
      end
      
      # make captures place
      captives.each do |enemy_group|
        enemy_group.captured
      end
      
      point.stone = stone
      @stones << stone
      @groups << group
    end
    
    def adjacent_points(point)
      x,y = point.x,point.y

      # collect adjacent points
      adjacent_points = []
      [[x+1,y],[x-1,y],[x,y+1],[x,y-1]].each do |c|
        @points.each do |p|
          if p.position == c
            adjacent_points << p
          end
        end
      end
      adjacent_points
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
    
  end # board

end # go