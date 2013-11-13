require_relative '../../test_helper'

module GameOfLife
  describe World do
    describe "#initialize" do
      it "should have a collection of cells" do
        world = World.new(1,1)

        world.cells.wont_be_nil
      end

      it "number of cells must be its width multiplied per its height" do
        world = World.new(5,3)
        world.cells.count.must_equal 5*3
      end

      it "must setup a matrix of cells, that represents the game board" do
        world = World.new(3,3)

        world.board.must_be_kind_of(Matrix)
      end
    end

    it "should be able to randomize some cells" do
      world = World.new(10,10)

      world.seed!

      world.live_cells.count.must_be(:>,0)
      world.dead_cells.count.must_be(:>,0)
    end

    describe "#live_neighbours_of" do
      it "should be able to count the live neighbours of a cell" do
        world = World.new(3,3)

        world.kill(0,0)
        world.kill(1,0)

        world.live_neighbours_of(1,1).count.must_equal 6
      end

      it "the cell (0,0) must have only 3 live neighbours" do
        world = World.new(3,3)

        world.live_neighbours_of(0,0).count.must_equal 3
      end
    end

    describe "#make_it_live" do
      it "should be able to make a dead cell live" do
        world = World.new(2,2)

        world.kill(1,1)
        world.get(1,1).dead?.must_equal true

        world.revive(1,1)
        world.get(1,1).dead?.must_equal false
      end
    end

    describe "#get" do
      it "should return a given cell" do
        world = World.new(2,2)

        cell_to_be_found = Cell.new(1,1)

        found_cell = world.get(1,1)

        found_cell.must_equal cell_to_be_found
      end
    end

    describe "#kill" do
      it "should be able to kill a cell" do
        world = World.new(2,2)

        world.dead_cells.count.must_equal 0
        world.kill(1,1)

        world.dead_cells.count.must_equal 1
      end
    end
  end
end
