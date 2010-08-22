test_dir = File.dirname(__FILE__) + '/..'
$LOAD_PATH.unshift test_dir unless $LOAD_PATH.include?(test_dir)
require 'test_helper'

module Go
  class StoneTest < Test::Unit::TestCase
    
    setup do
      @points = []
      @liberties = []
      [[4,5],[5,5],[6,5],[5,6],[5,4]].each do |coords|
        x,y = coords[0],coords[1]
        p = Go::Point.new x, y
        @points << p
      end
      @points.each do |p| 
        if p.position == [5,5]
          @point = p
        else
          @liberties << p
        end
      end
      
      @stone = Go::Stone.new(:black, @point, @liberties)
    end
    
    test "stone knows if it can breath" do
      assert @stone.can_breathe?
    end
    
    test "stone knows about its liberties" do
      assert_equal 4, @stone.liberties.length
      @liberties.each {|liberty| assert @stone.liberties.include?(liberty)}
    end
    
    test "stone knows if its liberties become occupied" do
      @liberties.first.stone = Go::Stone.new(:white, @liberties.first, nil)
      assert_equal 3, @stone.liberties.length
      assert @stone.can_breathe?
    end
    
    test "stone knows if it has gone into atari" do
      @liberties.each do |l|
        if @liberties.index(l) < 3
          l.stone = Go::Stone.new :white, l, nil
        end
      end
      assert @stone.in_atari?
    end
    
    test "stone knows if it has been captured" do
      @liberties.each do |l|
        l.stone = Go::Stone.new :white, l, nil
      end
      assert @stone.captured?
    end
    
    test "stone knows it has a friend but not how they're doing" do
      @liberties.first.stone = Go::Stone.new(:black, @liberties.first, nil)
      @liberties[1].stone,@liberties[2].stone = Go::Stone.new(:white, @liberties[1], nil), Go::Stone.new(:white, @liberties[2], nil)
      assert_raises JustASoldierError do
        @stone.in_atari?
      end
    end
    
    test "stone too lowly to know if it and all its friends have been captured" do
      @liberties.each do |l|
        if @liberties.index(l) < 3
          l.stone = Go::Stone.new :white, l, nil
        else
          l.stone = Go::Stone.new :black, l, nil
        end
      end
      assert_raises JustASoldierError do
        @stone.captured?
      end
    end
    
  end
end