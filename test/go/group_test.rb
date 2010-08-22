test_dir = File.dirname(__FILE__) + '/..'
$LOAD_PATH.unshift test_dir unless $LOAD_PATH.include?(test_dir)
require 'test_helper'

module Go
  class GroupTest < Test::Unit::TestCase
    
    setup do
      @point = Go::Point.new 5,5
      @point2 = Go::Point.new 5,6
      @point3 = Go::Point.new 5,4
      @point4 = Go::Point.new 5,7
      @stone = Go::Stone.new :black, @point, @point2, @point3
      @group = Go::Group.new @stone
    end
    
    test "groups know about their stones" do
      assert @group.stones
    end
    
    test "a stone knows what group it's in" do
      assert_equal @group, @stone.group
    end
    describe "multi stone group" do
      setup do
        @point = Go::Point.new 5,5
        @point2 = Go::Point.new 5,6
        @point3 = Go::Point.new 5,4
        @point4 = Go::Point.new 5,7
        @stone = Go::Stone.new(:black, @point, @point2, @point3)
        @group = Go::Group.new @stone
        @stone2 = Go::Stone.new(:black, @point2, @point4)
        
        @group.stones.push @stone2
      end
      
      test "group can include others" do
        assert_equal 2, @group.stones.length
      end
      
      test "groups know about their liberties" do
        assert @group.liberties.include?(@point3)
      end
    
      test "groups know when they're going into atari" do
        @point3.stone = Go::Stone.new(:white,@point3,nil)
        # @point4.stone = Go::Stone.new(:white,@point4,nil)
        assert_equal 1, @group.liberties.length
        assert @group.in_atari?
      end
    
      test "groups know when they're captured" do
      end
    
    end
  end
end