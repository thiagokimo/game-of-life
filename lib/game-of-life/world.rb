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
end
