dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)
require 'go/point'
require 'go/stone'
require 'go/group'
require 'go/board'
require 'go/game'

module Go
  
  
  class BoardError < StandardError
  end
  
  class MoveError < StandardError
  end
  
  class JustASoldierError < StandardError
  end
  
  class GameOverError < StandardError
  end

end


