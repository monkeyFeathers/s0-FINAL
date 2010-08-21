test_dir = File.dirname(__FILE__) + '/..'
$LOAD_PATH.unshift test_dir unless $LOAD_PATH.include?(test_dir)
require 'test_helper'

module Go
  class PointTest < Test::Unit::TestCase
    setup do
      @point = Go::Point.new(5,5)
    end
    
    test "point know's it's coordinates" do
      assert_equal [5,5], @point.position
    end
    
    test "point knows it is empty" do
      assert @point.empty?
    end
    
    test "point can contain a stone" do
      assert_nothing_raised do
        @point.stone = :white
      end
      
      assert_equal :white, @point.stone
    end
    
    test "cannot place on occupied point" do
      @point.stone = :white
      assert_raises MoveError do
        @point.stone = :white
        @point.stone = :black
      end
    end
    
    test "can be emptied" do
      @point.stone = :white
      @point.empty
      assert @point.empty?
    end
    
  end
end