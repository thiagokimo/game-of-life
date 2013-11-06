module GameOfLife
  class Cell
    attr_accessor :x, :y, :alive, :neighbours
    def initialize(x=0,y=0,alive=true)
      @x,@y = x,y
      @alive = alive
    end

    def ==(otherCell)
      (self.x == otherCell.x) and (self.y == otherCell.y)
    end

    def neighbours
      []
    end

    def alive?
      self.alive
    end

    def dead?
      not alive?
    end

    def reborn!
      @alive = true
    end

    def die!
      @alive = false
    end
  end
end
