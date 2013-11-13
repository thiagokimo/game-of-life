require_relative '../test_helper'

module GameOfLife
  describe "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    it "cells with 1 neighbour dies in the next day" do
      world = World.new(2,2)

      world.kill(0,0)
      world.kill(1,1)

      world.rotate!

      world.cells.each do |cell|
        cell.dead?.must_equal true
      end
    end

    it "a cell with no live neighbours should die in the next day" do
      world = World.new(3,3)

      world.kill(0,0)
      world.kill(1,0)
      world.kill(2,0)
      world.kill(0,1)
      world.kill(2,1)
      world.kill(0,2)
      world.kill(1,2)
      world.kill(2,2)

      world.rotate!

      world.get(1,1).dead?.must_equal true
    end
  end
end
