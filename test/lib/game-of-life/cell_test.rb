require_relative '../../test_helper'

module GameOfLife
  describe Cell do
    describe "coordinates" do
      it "coordinates" do
        cell = Cell.new
        cell.x.wont_be_nil
        cell.y.wont_be_nil
      end
      it "should store coordinates" do
        random_x = rand(11)
        random_y = rand(11)

        cell = Cell.new(random_x,random_y)

        cell.x.must_equal random_x
        cell.y.must_equal random_y
      end
    end

    describe "==" do
      it "should be true if 2 cells has the same coordinates" do
        cell_1 = Cell.new(1,2)
        cell_2 = Cell.new(1,2)

        cell_1.must_equal cell_2
      end

      it "should be false if 2 cells has different coordinates" do
        cell_1 = Cell.new(1,2)
        cell_2 = Cell.new(2,1)

        cell_1.wont_equal cell_2
      end
    end

    it "should be able to die" do
      cell = Cell.new

      cell.die!
      cell.dead?.must_equal true
    end

    it "should be dead or alive" do
      cell = Cell.new
      cell.alive.wont_be_nil
    end

    it "must have neighbours cells" do
      cell = Cell.new
      cell.neighbours.wont_be_nil
    end
  end
end
