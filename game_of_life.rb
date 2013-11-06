require 'minitest/autorun'

class GameOfLifeException < StandardError ; end
class CellAlreadyExistsInTheWorldException < GameOfLifeException ; end

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

  def die!
    @alive = false
  end
end

class World
  attr_accessor :cells

  def initialize
    @cells = []
  end

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
  end

  def create_cell(cell)
    raise CellAlreadyExistsInTheWorldException if exist?(cell)
    @cells << cell
  end

  private
  def apply_rule_1
    @cells.each do |cell|
      cell.die! if cell.alive? and live_neighbours_of(cell).count < 2
    end
  end

  def apply_rule_2
    @cells.each do |cell|
      cell.alive = true if live_neighbours_of(cell).count == 2 or live_neighbours_of(cell).count == 3
    end
  end
end

describe "The Game of Life" do
  describe "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    it "cells with 1 neighbour dies in the next day" do
      world = World.new
      world.create_cell(Cell.new(1,1))
      world.create_cell(Cell.new(2,1))

      world.create_cell(Cell.new(10,10))
      world.create_cell(Cell.new(10,11))

      world.rotate!

      world.cells.each do |cell|
        cell.dead?.must_equal true
      end
    end

    it "a cell with no live neighbours should die in the next day" do
      world = World.new
      world.create_cell(Cell.new(22,22))

      world.rotate!

      world.cells.first.dead?.must_equal true
    end
  end

  describe "Rule #2: Any live cell with two or three live neighbours lives on to the next generation." do
    it "a cell with 2 live neighbours will be alive in the next day" do
      world = World.new

      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      #        |        |
      cell_2 = Cell.new(-1,0)
      cell_1 = Cell.new(0,0)
      cell_3 = Cell.new(1,0)

      world.create_cell(cell_1)
      world.create_cell(cell_2)
      world.create_cell(cell_3)

      world.rotate!

      world.cells[0].alive?.must_equal true
      world.cells[1].dead?.must_equal true
      world.cells[2].dead?.must_equal true
    end
  end
end

describe World do

  it "should be able to count live neighbours of a cell" do
    world = World.new

    cell_1 = Cell.new(0,0)
    cell_2 = Cell.new(1,0)
    cell_3 = Cell.new(0,1)

    world.create_cell(cell_1)
    world.create_cell(cell_2)
    world.create_cell(cell_3)

    world.live_neighbours_of(cell_1).count.must_equal 2
  end

  describe "#find" do
    it "should return true if a cell with certain coordinates exists in its collection of cells" do
      world = World.new

      world.create_cell(Cell.new(1,2))
      world.create_cell(Cell.new(3,4))
      world.create_cell(Cell.new(5,6))
      world.create_cell(Cell.new(7,8))
      world.create_cell(Cell.new(9,0))

      world.exist?(Cell.new(1,2)).must_equal true
    end

    it "should return false if a cell with certain coordinates don't exists in its collection of cells" do
      world = World.new

      world.create_cell(Cell.new(1,2))
      world.create_cell(Cell.new(3,4))
      world.create_cell(Cell.new(5,6))
      world.create_cell(Cell.new(7,8))
      world.create_cell(Cell.new(9,0))

      world.exist?(Cell.new(300,400)).must_equal false
    end
  end

  it "should have a collection of cells" do
    world = World.new
    world.cells.wont_be_nil
  end

  describe "#create_cell" do
    it "should be able to create cells" do
      world = World.new

      random_x = rand(11)
      random_y = rand(11)
      cell = Cell.new(random_x,random_y)

      world.create_cell(cell)
      world.cells.must_include(cell)
    end

    it "should be allow creating cells if they don't exists in the world" do
      world = World.new
      cell = Cell.new

      lambda { world.create_cell(cell) }.must_be_silent
    end

    it "should not allow adding cells with the same coordinates" do
      world = World.new

      cell = Cell.new(1,1)
      same_cell = Cell.new(1,1)

      world.create_cell(cell)
      lambda { world.create_cell(same_cell)}.must_raise(CellAlreadyExistsInTheWorldException)
    end
  end
end

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


