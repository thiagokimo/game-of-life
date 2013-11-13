require_relative '../test_helper'

module GameOfLife
  describe "Rule #2: Any live cell with two or three live neighbours lives on to the next generation." do
    it "a cell with 2 live neighbours will be alive in the next day" do
      world = World.new(3,3)

      world.kill(0,2)
      world.kill(1,2)
      world.kill(2,2)
      world.kill(0,0)
      world.kill(1,0)
      world.kill(2,0)

      world.rotate!

      world.get(1,1).alive?.must_equal true
    end

    it "a cell with 3 live neighbours will be alive in the next day" do
      world = World.new(3,3)

      world.kill(1,1)
      world.kill(2,1)
      world.kill(1,0)
      world.kill(2,0)

      world.rotate!

      world.get(0,2).alive?.must_equal true
    end
  end
end
