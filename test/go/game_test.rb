test_dir = File.dirname(__FILE__) + '/..'
$LOAD_PATH.unshift test_dir unless $LOAD_PATH.include?(test_dir)
require 'test_helper'

module Go
  class GameTest < Test::Unit::TestCase
    
    setup do
      @game = Go::Game.new
    end
    
    
    test"not game over" do
      assert !@game.game_over?
    end
    
    test "black starts" do
      assert_nothing_raised do
        @game.black_move(5,5)
      end
    end
    
    test "white cannot start" do
      assert_raises Go::MoveError do
        @game.white_move(5,5)
      end
    end
    
    test "pass is valid move" do
      assert_nothing_raised do
        @game.black_move(:pass)
      end
    end
    
    test "two passes to finish game" do
      @game.black_move(:pass)
      @game.white_move(:pass)
      assert @game.game_over?
    end
    
    test "no more playing when game over" do
      @game.black_move(:pass)
      @game.white_move(:pass)
      assert_raises Go::GameOverError do
        @game.black_move(5,5)
      end
    end
    
  end
end