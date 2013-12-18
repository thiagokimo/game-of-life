require_relative 'game-of-life/exceptions'
require_relative 'game-of-life/cell'
require_relative 'game-of-life/world'
require_relative 'game-of-life/version'
require 'gosu'

module GameOfLife
  class GameOfLifeWindow < Gosu::Window
    def initialize(width=640, height=480)
      @width, @height = width, height
      super(@width, @height, false)
      self.caption = 'The Game of Life'

      # Variables
      @num_columns = @width/9
      @num_rows = @height/9
      @column_width = @width/@num_columns
      @row_height = @height/@num_rows

      @white_color = Gosu::Color.new(0xffffffff)
      @black_color = Gosu::Color.new(0xff000000)
      @dead_color = Gosu::Color.new(0xff808080)

      @world = World.new(@num_columns,@num_rows)
      @world.seed!
    end

    def update
      @world.rotate!
    end

    def draw
      draw_cells
    end

    def needs_cursor?
      true
    end

    def draw_cells
      @world.cells.each do |cell|
        if cell.alive?
          draw_quad(
            cell.x * @column_width, cell.y * @row_height, @white_color,
            cell.x * @column_width + @column_width, cell.y * @row_height, @white_color,
            cell.x * @column_width + @column_width, cell.y * @row_height + @row_height, @white_color,
            cell.x * @column_width, cell.y * @row_height + @row_height, @white_color
          )
        else
          draw_quad(
            cell.x * @column_width, cell.y * @row_height, @black_color,
            cell.x * @column_width + @column_width, cell.y * @row_height, @black_color,
            cell.x * @column_width + @column_width, cell.y * @row_height + @row_height, @black_color,
            cell.x * @column_width, cell.y * @row_height + @row_height, @black_color
          )
        end
      end
    end
  end
end
