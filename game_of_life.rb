require 'minitest/autorun'

class GameOfLifeException < StandardError ; end
class CellAlreadyExistsInTheWorldException < GameOfLifeException ; end
class CellIsAlreadyDeadException < GameOfLifeException ; end
class CellIsAlreadyAliveException < GameOfLifeException ; end

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

describe "The Game of Life" do
  describe "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    it "cells with 1 neighbour dies in the next day" do
      world = World.new
      world.create(Cell.new(1,1))
      world.create(Cell.new(2,1))

      world.create(Cell.new(10,10))
      world.create(Cell.new(10,11))

      world.rotate!

      world.cells.each do |cell|
        cell.dead?.must_equal true
      end
    end

    it "a cell with no live neighbours should die in the next day" do
      world = World.new
      world.create(Cell.new(22,22))

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

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)

      world.rotate!

      world.cells.first.alive?.must_equal true
    end

    it "a cell with 3 live neighbours will be alive in the next day" do
      world = World.new

      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      # cell_4 |        |
      # (-1,-1)
      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(-1,0)
      cell_3 = Cell.new(1,0)
      cell_4 = Cell.new(-1,-1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)
      world.create(cell_4)

      world.rotate!

      world.cells.first.alive?.must_equal true
    end
  end

  describe "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding." do
    it "a cell with 4 live neighbours will die in the next day" do
      world = World.new

      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      # -------|--------|-------
      # cell_4 | cell_5 |
      # (-1,-1)| (0,-1)
      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(-1,0)
      cell_3 = Cell.new(1,0)
      cell_4 = Cell.new(-1,-1)
      cell_5 = Cell.new(0,-1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)
      world.create(cell_4)
      world.create(cell_5)

      world.rotate!

      world.cells.first.dead?.must_equal true
    end

    it "a cell surrounded by live neighbours must die in the next day" do
      world = World.new

      # (-1,1) | (0,1)  | (1,1)
      # cell_7 | cell_8 | cell_9
      # -------|--------|-------
      # (-1,0) |  (0,0) |  (1,0)
      # cell_2 | cell_1 | cell_3
      # -------|--------|-------
      # cell_4 | cell_5 | cell_6
      # (-1,-1)| (0,-1) | (1,-1)
      cell_1 = Cell.new(0,0)
      cell_2 = Cell.new(-1,0)
      cell_3 = Cell.new(1,0)
      cell_4 = Cell.new(-1,-1)
      cell_5 = Cell.new(0,-1)
      cell_6 = Cell.new(1,-1)
      cell_7 = Cell.new(-1,1)
      cell_8 = Cell.new(0,1)
      cell_9 = Cell.new(1,1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_3)
      world.create(cell_4)
      world.create(cell_5)
      world.create(cell_6)
      world.create(cell_7)
      world.create(cell_8)
      world.create(cell_9)

      world.rotate!

      world.cells.first.dead?.must_equal true
    end
  end

  describe "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
    it "a dead cell with 3 neighbours will reborn in the next day" do
      world = World.new

      # (-1,1) |        |
      # cell_7 |        |
      # -------|--------|-------
      # (-1,0) |  (0,0) |
      # cell_2 | cell_1 |
      # -------|--------|-------
      # cell_4 |        |
      # (-1,-1)|        |
      cell_1 = Cell.new(0,0,false)
      cell_2 = Cell.new(-1,0)
      cell_4 = Cell.new(-1,-1)
      cell_7 = Cell.new(-1,1)

      world.create(cell_1)
      world.create(cell_2)
      world.create(cell_4)
      world.create(cell_7)

      world.rotate!

      world.cells.first.alive?.must_equal true
    end
  end
end

describe World do

  it "should be able to give all its dead cells" do
    world = World.new

    cell_1 = Cell.new(0,0,false)
    cell_2 = Cell.new(1,0)
    cell_3 = Cell.new(0,1,false)

    world.create(cell_1)
    world.create(cell_2)
    world.create(cell_3)

    world.dead_cells.count.must_equal 2
  end

  it "should be able to give all its live cells" do
    world = World.new

    cell_1 = Cell.new(0,0,false)
    cell_2 = Cell.new(1,0)
    cell_3 = Cell.new(0,1,false)

    world.create(cell_1)
    world.create(cell_2)
    world.create(cell_3)

    world.live_cells.count.must_equal 1
  end

  it "should be able to count live neighbours of a cell" do
    world = World.new

    cell_1 = Cell.new(0,0)
    cell_2 = Cell.new(1,0)
    cell_3 = Cell.new(0,1)

    world.create(cell_1)
    world.create(cell_2)
    world.create(cell_3)

    world.live_neighbours_of(cell_1).count.must_equal 2
  end

  describe "#find" do
    it "should return true if a cell with certain coordinates exists in its collection of cells" do
      world = World.new

      world.create(Cell.new(1,2))
      world.create(Cell.new(3,4))
      world.create(Cell.new(5,6))
      world.create(Cell.new(7,8))
      world.create(Cell.new(9,0))

      world.exist?(Cell.new(1,2)).must_equal true
    end

    it "should return false if a cell with certain coordinates don't exists in its collection of cells" do
      world = World.new

      world.create(Cell.new(1,2))
      world.create(Cell.new(3,4))
      world.create(Cell.new(5,6))
      world.create(Cell.new(7,8))
      world.create(Cell.new(9,0))

      world.exist?(Cell.new(300,400)).must_equal false
    end
  end

  it "should have a collection of cells" do
    world = World.new
    world.cells.wont_be_nil
  end

  describe "#revive" do
    it "should revive a dead cell" do
      world = World.new
      cell = Cell.new(0,0,false)

      world.create(cell)
      world.revive(cell)

      world.cells.first.alive?.must_equal true
    end

    it "must raise an exception if trying to revive a live cell" do
      world = World.new
      cell = Cell.new

      world.create(cell)
      lambda { world.revive(cell) }.must_raise(CellIsAlreadyAliveException)
    end
  end

  describe "#kill" do
    it "should be able to kill a cell" do
      world = World.new
      cell = Cell.new(0,0)

      world.create(cell)
      world.kill(cell)

      world.cells.first.dead?.must_equal true
    end

    it "should raise an exception is trying to kill a cell that is already dead" do
      world = World.new
      cell = Cell.new(0,0,false)

      world.create(cell)
      lambda { world.kill(cell) }.must_raise(CellIsAlreadyDeadException)
    end
  end

  describe "#create" do
    it "should be able to create cells" do
      world = World.new

      random_x = rand(11)
      random_y = rand(11)
      cell = Cell.new(random_x,random_y)

      world.create(cell)
      world.cells.must_include(cell)
    end

    it "should be allow creating cells if they don't exists in the world" do
      world = World.new
      cell = Cell.new

      lambda { world.create(cell) }.must_be_silent
    end

    it "should not allow adding cells with the same coordinates" do
      world = World.new

      cell = Cell.new(1,1)
      same_cell = Cell.new(1,1)

      world.create(cell)
      lambda { world.create(same_cell)}.must_raise(CellAlreadyExistsInTheWorldException)
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

