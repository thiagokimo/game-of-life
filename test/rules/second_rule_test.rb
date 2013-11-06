require_relative '../test_helper'

module GameOfLife
  describe "Rule #2: Any live cell with two or three live neighbours lives on to the next generation." do
    it "a cell with 2 live neighbours will be alive in the next day" do
      world = World.new

      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      #        |        |
      cell_2 = Cell.new(-1,0)
      cell_1 = Cell.new(0,0)
      cell_3 = Cell.new(1,0)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)

      world.rotate!

      world.cells.first.alive?.must_equal true
    end

    it "a cell with 3 live neighbours will be alive in the next day" do
      world = World.new

      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      # cell_4 |        |
      # (-1,-1)
      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(-1,0)
      cell_3 = Cell.new(1,0)
      cell_4 = Cell.new(-1,-1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)
      world.create(cell_4)

      world.rotate!

      world.cells.first.alive?.must_equal true
    end
  end
end
