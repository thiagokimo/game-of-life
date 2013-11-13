require_relative '../test_helper'

module GameOfLife
  describe "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding." do
    it "a cell with 4 live neighbours will die in the next day" do
      world = World.new(3,3)

      world.kill(0,2)
      world.kill(1,2)
      world.kill(2,2)
      world.kill(2,0)

      world.rotate!

      world.get(1,1).dead?.must_equal true
    end

    it "a cell surrounded by live neighbours must die in the next day" do
      world = World.new(3,3)

      world.rotate!

      world.get(1,1).dead?.must_equal true
    end
  end
end
