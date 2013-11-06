module GameOfLife
  class World
    attr_accessor :cells

    def initialize
      @cells = []
    end

    def dead_cells
      @cells - live_cells
    end

    def live_cells
      live_cells = []

      @cells.each do |cell|
        live_cells << cell if cell.alive?
      end

      live_cells
    end

    # up_left   | up   | up_right
    # ----------|------|-----------
    # left      | cell | right
    # ----------|------|-----------
    # down_left | down | down_right
    def live_neighbours_of(cell)
      live_neighbours = []

      up_left = Cell.new(cell.x-1,cell.y+1)
      up = Cell.new(cell.x,cell.y+1)
      up_right = Cell.new(cell.x+1,cell.y+1)
      left = Cell.new(cell.x-1,cell.y)
      right = Cell.new(cell.x+1,cell.y)
      down_left = Cell.new(cell.x-1,cell.y-1)
      down = Cell.new(cell.x,cell.y-1)
      down_right = Cell.new(cell.x+1,cell.y-1)

      neighbour_candidates = [up_left,up,up_right,left,right,down_left,down,down_right]

      neighbour_candidates.each do |neighbour|
        live_neighbours << @cells[@cells.index(neighbour)] if exist?(neighbour) and neighbour.alive?
      end

      live_neighbours
    end

    def exist?(cell)
      @cells.include? cell
    end

    def rotate!
      apply_rule_1
      apply_rule_2
      apply_rule_3
      apply_rule_4
    end

    def create(cell)
      raise CellAlreadyExistsInTheWorldException if exist?(cell)
      @cells << cell
    end

    def revive(cell)
      raise CellIsAlreadyAliveException if exist?(cell) and cell.alive?
      @cells[@cells.index(cell)].reborn!
    end

    def kill(cell)
      raise CellIsAlreadyDeadException if exist?(cell) and cell.dead?
      @cells[@cells.index(cell)].die!
    end

    private
    def apply_rule_1
      live_cells.each do |cell|
        kill(cell) if cell.alive? and live_neighbours_of(cell).count < 2
      end
    end

    def apply_rule_2
      # live_cells.each do |cell|
      #   revive(cell) if live_neighbours_of(cell).count == 2 or live_neighbours_of(cell).count == 3
      # end
    end

    def apply_rule_3
      live_cells.each do |cell|
        kill(cell) if cell.alive? and live_neighbours_of(cell).count > 3
      end
    end

    def apply_rule_4
      dead_cells.each do |cell|
        revive(cell) if cell.dead? and live_neighbours_of(cell) == 3
      end
    end
  end

end
