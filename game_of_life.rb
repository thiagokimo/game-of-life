require 'minitest/autorun'

class GameOfLifeException < StandardError ; end
class UndefinedCellPosition < GameOfLifeException ; end
class UndefinedWorldForCell < GameOfLifeException ; end

module CellHelpers
  UP_LEFT = 0
  UP = 1
  UP_RIGHT = 2
  LEFT = 3
  RIGHT = 4
  DOWN_LEFT = 5
  DOWN = 6
  DOWN_RIGHT = 7
end

class GameOfLife
end

class Cell
  attr_reader :x,:y, :neighbours
  attr_accessor :world

  def initialize(x=0,y=0,world)
    @x,@y = x,y

    raise UndefinedWorldForCell unless world
    @world = world
    @world.cells << self
  end

  def ==(otherCell)
    (self.x == otherCell.x) and (self.y == otherCell.y)
  end

  def neighbours
    @neighbours = []
    @world.cells.each do |cell|

      # CellHelpers::UP_LEFT
      if self.x == cell.x+1 and self.y == cell.y-1
        @neighbours << cell
      # CellHelpers::UP
      elsif self.x == cell.x and self.y == cell.y-1
        @neighbours << cell
        # CellHelpers::UP_RIGHT
      elsif self.x == cell.x-1 and self.y == cell.y-1
        @neighbours << cell
      # CellHelpers::LEFT
      elsif self.x == cell.x+1 and self.y == cell.y
        @neighbours << cell
      # CellHelpers::RIGHT
      elsif self.x == cell.x-1 and self.y == cell.y
        @neighbours << cell
      # CellHelpers::DOWN_LEFT
      elsif self.x == cell.x+1 and self.y == cell.y+1
        @neighbours << cell
      # CellHelpers::DOWN
      elsif self.x == cell.x and self.y == cell.y+1
        @neighbours << cell
      # CellHelpers::DOWN_RIGHT
      elsif self.x == cell.x-1 and self.y == cell.y+1
        @neighbours << cell
      end
    end

    @neighbours
  end

  def create_neighbour(position)
    case position
      when CellHelpers::UP_LEFT
        Cell.new(self.x-1,self.y+1,@world)
      when CellHelpers::UP
        Cell.new(self.x,self.y+1,@world)
      when CellHelpers::UP_RIGHT
        Cell.new(self.x+1,self.y+1,@world)
      when CellHelpers::LEFT
        Cell.new(self.x-1,self.y,@world)
      when CellHelpers::RIGHT
        Cell.new(self.x+1,self.y,@world)
      when CellHelpers::DOWN_LEFT
        Cell.new(self.x-1,self.y-1,@world)
      when CellHelpers::DOWN
        Cell.new(self.x,self.y-1,@world)
      when CellHelpers::DOWN_RIGHT
        Cell.new(self.x+1,self.y-1,@world)
    else
      raise UndefinedCellPosition
    end
  end

  def alive?
    @world.cells.include? self
  end

  def die!
    @world.cells -= [self]
  end

  def dead?
    not @world.cells.include? self
  end
end

class World
  attr_accessor :cells
  def initialize
    @cells = []
  end

  def rotate!
    apply_rules
  end

  private
  def apply_rules
    @cells.each do |cell|
      rule_1(cell)
      rule_2(cell)
      rule_3(cell)
    end
  end

  def rule_1(cell)
    if cell.neighbours.count < 2
      cell.die!
    end
  end

  def rule_2(cell)
    # @cells.each do |cell|
    #   if cell.neighbours.count == 2 or cell.neighbours.count == 3

    #   end
    # end
  end

  def rule_3(cell)
    if cell.neighbours.count > 3
      cell.die!
    end
  end
end

describe GameOfLife do
  describe "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    it "a cell with no neighbour should die in the next round" do
      world = World.new
      cell = Cell.new(world)

      world.rotate!

      world.cells.include?(cell).must_equal false
      world.cells.count.must_equal 0
    end

    it "cells with one neighbour should die in the next round" do
      world = World.new
      cell = Cell.new(world)

      cell.create_neighbour(CellHelpers::UP)
      neighbour = cell.neighbours.first

      world.rotate!

      cell.dead?.must_equal true
      neighbour.dead?.must_equal true
    end
  end

  describe "Rule #2: Any live cell with two or three live neighbours lives on to the next generation." do
    it "a cell with two neighbours, one on the left and the other on the right, should live in the next round" do
      world = World.new
      cell = Cell.new(world)

      cell.create_neighbour(CellHelpers::LEFT)
      cell.create_neighbour(CellHelpers::RIGHT)

      world.rotate!

      cell.alive?.must_equal true
    end
  end

  describe "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding." do
    it "should die if its has more than 3 neighbours" do
      world = World.new
      cell = Cell.new(world)

      cell.create_neighbour(CellHelpers::UP)
      cell.create_neighbour(CellHelpers::DOWN)
      cell.create_neighbour(CellHelpers::LEFT)
      cell.create_neighbour(CellHelpers::RIGHT)

      world.rotate!

      cell.dead?.must_equal true
    end
  end

  describe "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
    # OH SHIT!
    it "should produce a cell when an empty spot has exactly 3 neighbours"
  end

  describe Cell do
    it "should be able to check its number of neighbours" do
      cell = Cell.new(World.new)

      cell.create_neighbour(CellHelpers::UP)
      cell.create_neighbour(CellHelpers::DOWN)

      cell.neighbours.count.must_equal 2
    end

    it "must have the correct neighbours" do
      cell = Cell.new(World.new)
      cell.create_neighbour(CellHelpers::RIGHT)

      cell.neighbours.first.must_equal Cell.new(1,0,World.new)
    end

    it "should not exist in the world if is dead" do
      world = World.new
      cell = Cell.new(world)
      cell.die!

      world.rotate!

      world.cells.include?(cell).must_equal false
    end
  end
end

