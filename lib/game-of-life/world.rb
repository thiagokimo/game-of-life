require 'matrix'

module GameOfLife
  class World
    attr_accessor :cells, :board

    def initialize(width,height)
      @width, @height = width, height
      setup(false)
    end

    def seed!
      clean_cells
      setup(true)
    end

    def live_cells
      @cells.select { |cell| cell.alive? }
    end

    def dead_cells
      @cells.select { |cell| cell.dead? }
    end

    def kill(x,y)
      @board.element(x,y).die!
    end

    def get(x,y)
      @board.element(x,y)
    end

    def revive(x,y)
      @board.element(x,y).reborn!
    end

    def live_neighbours_of(x,y)
      live_neighbours = []

      # up-left
      if x-1 >= 0 and y+1 <= @height-1
        neighbour = get(x-1,y+1)
        live_neighbours << neighbour if neighbour.alive?
      end

      # up
      if y+1 <= @height-1
        neighbour = get(x,y+1)
        live_neighbours << neighbour if neighbour.alive?
      end

      # up-right
      if x+1 <= @width-1 and y+1 <= @height-1
        neighbour = get(x+1,y+1)
        live_neighbours << neighbour if neighbour.alive?
      end

      # left
      if x-1 >= 0
        neighbour = get(x-1,y)
        live_neighbours << neighbour if neighbour.alive?
      end

      # right
      if x+1 <= @width-1
        neighbour = get(x+1,y)
        live_neighbours << neighbour if neighbour.alive?
      end

      # down-left
      if x-1 >= 0 and y-1 >= 0
        neighbour = get(x-1,y-1)
        live_neighbours << neighbour if neighbour.alive?
      end

      # down
      if y-1 >= 0
        neighbour = get(x,y-1)
        live_neighbours << neighbour if neighbour.alive?
      end

      # down-right
      if x+1 <= @width-1 and y-1 >= 0
        neighbour = get(x+1,y-1)
        live_neighbours << neighbour if neighbour.alive?
      end

      live_neighbours
    end

    def rotate!
      future_alive_cells = []
      future_dead_cells = []

      @cells.each do |cell|
        live_neighbours = live_neighbours_of(cell.x,cell.y)

        future_dead_cells << cell if apply_rule_1(cell,live_neighbours)
        future_alive_cells << cell if apply_rule_2(cell,live_neighbours)
        future_dead_cells << cell if apply_rule_3(cell,live_neighbours)
        future_alive_cells << cell if apply_rule_4(cell,live_neighbours)
      end

      update_board(future_alive_cells,future_dead_cells)
      update_cells
    end

    private
    def apply_rule_1(cell,live_neighbours)
      cell.alive? and live_neighbours.count < 2
    end

    def apply_rule_2(cell,live_neighbours)
      cell.alive? and (live_neighbours.count == 2 or live_neighbours.count == 3)
    end

    def apply_rule_3(cell,live_neighbours)
      cell.alive? and live_neighbours.count > 3
    end

    def apply_rule_4(cell,live_neighbours)
      cell.dead? and live_neighbours.count == 3
    end

    def rebuild_board(live_cells,dead_cells)
      (live_cells+dead_cells).each do |cell|
        @board.set(cell.x,cell.y,cell)
      end
    end

    def setup(random)
      @board = Matrix.build(@width, @height) { |row,column|
        if random
          cell = Cell.new(row,column,[true,false].sample)
        else
          cell = Cell.new(row,column)
        end
      }

      update_cells
    end

    def update_board(to_live,to_die)
      to_live.each do |cell|
        revive(cell.x,cell.y)
      end
      to_die.each do |cell|
        kill(cell.x,cell.y)
      end
    end

    def update_cells
      @cells = @board.to_a.flatten!
    end

    def clean_cells
      @cells = nil
      @board = nil
    end
  end
  # class World
  #   attr_accessor :cells, :board
  #   attr_reader :width, :height

  #   def initialize(width=10, height=10, allow_negative_cells=true)
  #     @width, @height = width, height
  #     @negative = allow_negative_cells
  #     @cells = []

  #     setup_board
  #   end

  #   def dead_cells
  #     @cells.select { |cell| cell.dead? }
  #   end

  #   def live_cells
  #     @cells.select { |cell| cell.alive? }
  #   end

  #   def seed!
  #     for x in (0).upto(@width-1) do
  #       for y in (0).upto(@height-1) do
  #         cell = Cell.new(x,y,[true,false].sample)
  #         @cells << cell
  #         @board[x][y] = cell
  #       end
  #     end
  #   end

  #   # up_left   | up   | up_right
  #   # ----------|------|-----------
  #   # left      | cell | right
  #   # ----------|------|-----------
  #   # down_left | down | down_right
  #   def live_neighbours_of(cell)
  #     live_neighbours = []

  #     up_left = Cell.new(cell.x-1,cell.y+1)
  #     up = Cell.new(cell.x,cell.y+1)
  #     up_right = Cell.new(cell.x+1,cell.y+1)
  #     left = Cell.new(cell.x-1,cell.y)
  #     right = Cell.new(cell.x+1,cell.y)
  #     down_left = Cell.new(cell.x-1,cell.y-1)
  #     down = Cell.new(cell.x,cell.y-1)
  #     down_right = Cell.new(cell.x+1,cell.y-1)

  #     neighbour_candidates = [up_left,up,up_right,left,right,down_left,down,down_right]

  #     neighbour_candidates.each do |neighbour|
  #       live_neighbours << @board[neighbour.x][neighbour.y] if not outside_of_the_world?(neighbour) and neighbour.alive?
  #     end

  #     live_neighbours
  #   end

  #   def exist?(cell)
  #     @cells.include? cell
  #   end

  #   def rotate!
  #     future_alive_cells = []
  #     future_dead_cells = []

  #     @cells.each do |cell|
  #       num_live_neighbours = live_neighbours_of(cell).count

  #       # Rule #1
  #       if cell.alive? and num_live_neighbours < 2
  #         future_dead_cells << cell
  #       end

  #       # Rule #2
  #       if live_neighbours_of(cell).count == 2 or live_neighbours_of(cell).count == 3
  #         future_alive_cells << cell
  #       end

  #       # Rule #3
  #       if cell.alive? and num_live_neighbours > 3
  #         future_dead_cells << cell
  #       end

  #       # Rule #4
  #       if cell.dead? and num_live_neighbours == 3
  #         future_alive_cells << cell
  #       end

  #       update_cells(future_alive_cells,future_dead_cells)
  #     end
  #   end

  #   def create(cell)
  #     # raise CellAlreadyExistsInTheWorldException if exist?(cell)
  #     raise CellInvalidCoordinatesException if outside_of_the_world?(cell) or negative_coordinates?(cell)
  #     @cells << cell
  #   end

  #   def revive(cell)
  #     raise CellIsAlreadyAliveException if exist?(cell) and cell.alive?
  #     cell.reborn!
  #   end

  #   def kill(cell)
  #     raise CellIsAlreadyDeadException if exist?(cell) and cell.dead?
  #     cell.die!
  #   end

  #   private
    # def setup_board
    #   @board = Array.new(@width) do |row|
    #     Array.new(@height) do |column|
    #       Cell.new(row,column)
    #     end
    #   end

    #   @board.each do |row|
    #     row.each do |column|
    #       @cells << column
    #     end
    #   end
    # end

  #   def update_cells(alives,deads)
  #     alives.each do |cell|
  #       cell.reborn!
  #     end
  #     deads.each do |cell|
  #       cell.die!
  #     end
  #   end

  #   def apply_rule_1(cell,number_of_live_neighbours)
  #     kill(cell) if cell.alive? and number_of_live_neighbours < 2
  #   end

  #   def apply_rule_2(cell)
  #     # revive(cell) if live_neighbours_of(cell).count == 2 or live_neighbours_of(cell).count == 3
  #   end

  #   def apply_rule_3(cell,number_of_live_neighbours)
  #     kill(cell) if cell.alive? and number_of_live_neighbours > 3
  #   end

  #   def apply_rule_4(cell,number_of_live_neighbours)
  #     revive(cell) if cell.dead? and number_of_live_neighbours == 3
  #   end

  #   def outside_of_the_world?(cell)
  #     (cell.x > @width) or (cell.y > @height)
  #   end

  #   def negative_coordinates?(cell)
  #     (cell.x < 0) or (cell.y < 0) and not @negative
  #   end
  # end
end
