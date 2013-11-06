require_relative '../test_helper'

module GameOfLife
  describe "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
    it "a dead cell with 3 neighbours will reborn in the next day" do
      world = World.new

      # (-1,1) |        |
      # cell_7 |        |
      # -------|--------|-------
      # (-1,0) |  (0,0) |
      # cell_2 | cell_1 |
      # -------|--------|-------
      # cell_4 |        |
      # (-1,-1)|        |
      cell_1 = Cell.new(0,0,false)
      cell_2 = Cell.new(-1,0)
      cell_4 = Cell.new(-1,-1)
      cell_7 = Cell.new(-1,1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_4)
      world.create(cell_7)

      world.rotate!

      world.cells.first.alive?.must_equal true
    end
  end
end
