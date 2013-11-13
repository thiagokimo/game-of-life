require_relative '../test_helper'

module GameOfLife
  describe "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
    it "a dead cell with 3 live neighbours will reborn in the next day" do
      world = World.new(3,3)

      # (0,2) (1,2) (2,2)
      # (0,1) (1,1) (2,1)
      # (0,0) (1,0) (2,0)

      world.kill(1,2)
      world.kill(2,2)
      world.kill(2,1)
      world.kill(2,0)
      world.kill(1,0)
      world.kill(1,1)

      world.rotate!

      world.get(1,1).alive?.must_equal true
    end
  end
end
