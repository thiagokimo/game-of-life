require_relative '../test_helper'

module GameOfLife
  describe "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding." do
    it "a cell with 4 live neighbours will die in the next day" do
      world = World.new

      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      # -------|--------|-------
      # cell_4 | cell_5 |
      # (-1,-1)| (0,-1)
      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(-1,0)
      cell_3 = Cell.new(1,0)
      cell_4 = Cell.new(-1,-1)
      cell_5 = Cell.new(0,-1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)
      world.create(cell_4)
      world.create(cell_5)

      world.rotate!

      world.cells.first.dead?.must_equal true
    end

    it "a cell surrounded by live neighbours must die in the next day" do
      world = World.new

      # (-1,1) | (0,1)  | (1,1)
      # cell_7 | cell_8 | cell_9
      # -------|--------|-------
      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      # -------|--------|-------
      # cell_4 | cell_5 | cell_6
      # (-1,-1)| (0,-1) | (1,-1)
      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(-1,0)
      cell_3 = Cell.new(1,0)
      cell_4 = Cell.new(-1,-1)
      cell_5 = Cell.new(0,-1)
      cell_6 = Cell.new(1,-1)
      cell_7 = Cell.new(-1,1)
      cell_8 = Cell.new(0,1)
      cell_9 = Cell.new(1,1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)
      world.create(cell_4)
      world.create(cell_5)
      world.create(cell_6)
      world.create(cell_7)
      world.create(cell_8)
      world.create(cell_9)

      world.rotate!

      world.cells.first.dead?.must_equal true
    end
  end
end
