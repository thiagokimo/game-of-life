require 'test_helper'

module GameOfLife
  describe "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    it "cells with 1 neighbour dies in the next day" do
      world = World.new
      world.create(Cell.new(1,1))
      world.create(Cell.new(2,1))

      world.create(Cell.new(10,10))
      world.create(Cell.new(10,11))

      world.rotate!

      world.cells.each do |cell|
        cell.dead?.must_equal true
      end
    end

    it "a cell with no live neighbours should die in the next day" do
      world = World.new
      world.create(Cell.new(22,22))

      world.rotate!

      world.cells.first.dead?.must_equal true
    end
  end
end
