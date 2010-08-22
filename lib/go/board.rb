module Go
  
  class Board
    
    attr_accessor :stones, :occupied_points, :points, :groups
    
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
          @dimensions = dimensions.first
        end
      end
      @stones = []
      @occupied_points = []
      @chains = []
      @groups = []
    end
    
    def place_stone(player, *position)
      # check that move is valid
      position.flatten!
      # x, y?
      x,y = "",""
      case position.length
      when 2
        x, y = position[0],position[1]
        [x,y].each do |c|
          unless c > 0 and c <= @dimensions
            raise Go::MoveError, "move (#{x}, #{y}) not on board"
          end
        end
      else
        raise Go::MoveError, "need (x, y) to move"
      end
      
      # get point and adjacent points
      
      point = ""
      @points.each do |p|
        if p.position == [x,y]
          point = p
        end
      end
      
      unless point.class == Go::Point
        raise Go::MoveError, "couldn't find point"
      end
      
      # ko?
      if point.ko?
        raise Go::MoveError, "Move is invalid due to Ko"
      end
      
      adjacents = adjacent_points point
      
      # separate adjacent enemies and friends and liberties
      friendly_points = []
      enemy_points = []
      free_points = []
      adjacents.each do |pnt|
        case pnt.stone
        when nil
          free_points << pnt
        else
          if pnt.stone.color == player
            friendly_points << pnt
          else
            enemy_points << pnt
          end
        end
      end
      
      # would stone placement capture any enemy groups?
      
      potential_captives = []
      enemy_points.each do |enemy|
        if enemy.stone.group.in_atari?
          if point == enemy.stone.group.liberty.last
            potential_captives << enemy.stone.group
          end
        end
      end
      
      # check for suicide
      if potential_captives.empty?
        if free_points.empty?
        # check friendly group 
          if friendly_points.empty?
            raise Go::MoveError, "Move would result in suicide"
          else
            friendly_points.each do |friend|
              if friend.group.in_atari?
                if friend.group.liberties.last == point
                  raise Go::MoveError, "Move would result in suicide"
                end
              end
            end
          end
        end
      end
      
      # figure out the group it belongs to
      group = ""
      case friendly_points.length
      when 0
        group = lambda do |s| 
          g = Go::Group.new s
          @groups << g
        end
          
      when 1
        group = friendly_points.first.group
      else
        # find out if friends in same group or different ones
        grps = []
        friendly_points.each {|f| grps << f.stone.group}
        if grps.uniq.length == 1
          group = grps.first
        else
          stns = []
          grps.each do |grp|
            stns << grp.stones
            @groups.delete grp
          end
          g = Go::Group.new stns
          @groups << g
          group = lambda{|s| g.add s} 
        end
      end
      
      # place stone add to group and make captures
      stone = Go::Stone.new(player, point, free_points)
      @stones << stone
      stone.occupy
      group.call stone
      
      potential_captives.each do |p|
        p.stone.group.captured
      end
      
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