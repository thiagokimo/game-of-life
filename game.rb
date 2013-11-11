require 'gosu'
require './lib/game_of_life'

class GameOfLifeWindow < Gosu::Window
  def initialize(width=640, height=480)
    @width, @height = width, height
   super(@width, @height, false)
   self.caption = 'The Game of Life'
  end

  def update
  end

  def draw

  end

  def needs_cursor?
    true
  end
end

window = GameOfLifeWindow.new
window.show
