test_dir = File.dirname(__FILE__) + '/..'
$LOAD_PATH.unshift test_dir unless $LOAD_PATH.include?(test_dir)
require 'test_helper'

module Go
  class BoardTest < Test::Unit::TestCase
    describe "new board needs to know it's dimensions" do
      setup do
        @board = Go::Board.new
      end
      
      test "board defaults to 9X9" do
        assert_equal 81, @board.points.length
      end
      
      test "board will take a single parameter and square it" do
        board = Go::Board.new(10)
        assert_equal 100, board.points.length
      end
      
      test "board will take two parameters LxW to determine dimensions that are equal" do
        assert_nothing_raised do
          board = Go::Board.new(9,9)
        end
        assert_raises Go::BoardError do
          board = Go::Board.new(9,7)
        end
        
      end
      
    end # new board dimensions
    
    describe "board knows which points have stones and which do not" do
      setup do
        @board = Go::Board.new
        @board.place_stone :black, 5,5
      end
      
      test "single occupied points" do
        assert_equal 1, @board.stones.length
        assert_equal [5,5], @board.stones.first.point.position
      end
      
      test "cannot place stone on occupied points" do
        assert_raises Go::MoveError do
          @board.place_stone :white, 5,5
        end
      end
      
    end # which points have stones
    describe "board knows about liberties and atari" do
      
      context "single stone" do
        
        setup do
          @board = Go::Board.new
          @board.place_stone :black, 5,5
        end
        
        
        test "stone has liberties" do
        end
        
      end # single stone context
      
      context "groups" do
        setup do
         @board = Go::Board.new
         [[6,5], [5,6], [5,5]].each do |point|
           @board.place_stone :black, point.flatten
         end
        end
            
        test "board knows about its groups" do
          assert_equal 1, @board.groups.length
        end
      end
    end
  
  end
end