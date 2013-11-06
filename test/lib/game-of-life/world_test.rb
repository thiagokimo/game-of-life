require_relative '../../test_helper'

module GameOfLife
  describe World do
    it "should be able to give all its dead cells" do
      world = World.new

      cell_1 = Cell.new(0,0,false)
      cell_2 = Cell.new(1,0)
      cell_3 = Cell.new(0,1,false)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)

      world.dead_cells.count.must_equal 2
    end

    it "should be able to give all its live cells" do
      world = World.new

      cell_1 = Cell.new(0,0,false)
      cell_2 = Cell.new(1,0)
      cell_3 = Cell.new(0,1,false)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)

      world.live_cells.count.must_equal 1
    end

    it "should be able to count live neighbours of a cell" do
      world = World.new

      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(1,0)
      cell_3 = Cell.new(0,1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)

      world.live_neighbours_of(cell_1).count.must_equal 2
    end

    describe "#find" do
      it "should return true if a cell with certain coordinates exists in its collection of cells" do
        world = World.new

        world.create(Cell.new(1,2))
        world.create(Cell.new(3,4))
        world.create(Cell.new(5,6))
        world.create(Cell.new(7,8))
        world.create(Cell.new(9,0))

        world.exist?(Cell.new(1,2)).must_equal true
      end

      it "should return false if a cell with certain coordinates don't exists in its collection of cells" do
        world = World.new

        world.create(Cell.new(1,2))
        world.create(Cell.new(3,4))
        world.create(Cell.new(5,6))
        world.create(Cell.new(7,8))
        world.create(Cell.new(9,0))

        world.exist?(Cell.new(300,400)).must_equal false
      end
    end

    it "should have a collection of cells" do
      world = World.new
      world.cells.wont_be_nil
    end

    describe "#revive" do
      it "should revive a dead cell" do
        world = World.new
        cell = Cell.new(0,0,false)

        world.create(cell)
        world.revive(cell)

        world.cells.first.alive?.must_equal true
      end

      it "must raise an exception if trying to revive a live cell" do
        world = World.new
        cell = Cell.new

        world.create(cell)
        lambda { world.revive(cell) }.must_raise(CellIsAlreadyAliveException)
      end
    end

    describe "#kill" do
      it "should be able to kill a cell" do
        world = World.new
        cell = Cell.new(0,0)

        world.create(cell)
        world.kill(cell)

        world.cells.first.dead?.must_equal true
      end

      it "should raise an exception is trying to kill a cell that is already dead" do
        world = World.new
        cell = Cell.new(0,0,false)

        world.create(cell)
        lambda { world.kill(cell) }.must_raise(CellIsAlreadyDeadException)
      end
    end

    describe "#create" do
      it "should be able to create cells" do
        world = World.new

        random_x = rand(11)
        random_y = rand(11)
        cell = Cell.new(random_x,random_y)

        world.create(cell)
        world.cells.must_include(cell)
      end

      it "should be allow creating cells if they don't exists in the world" do
        world = World.new
        cell = Cell.new

        lambda { world.create(cell) }.must_be_silent
      end

      it "should not allow adding cells with the same coordinates" do
        world = World.new

        cell = Cell.new(1,1)
        same_cell = Cell.new(1,1)

        world.create(cell)
        lambda { world.create(same_cell)}.must_raise(CellAlreadyExistsInTheWorldException)
      end
    end
  end
end
