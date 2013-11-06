require 'minitest/autorun'

class Cell
  attr_accessor :x, :y, :alive, :neighbours
  def initialize(x=0,y=0,alive=true)
    @x,@y = x,y
    @alive = alive
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

  def rotate!
    apply_rule_1
  end

  def create_cell(cell)
    @cells << cell
  end

  private
  def apply_rule_1
    @cells.each do |cell|
      cell.die! if cell.alive? and cell.neighbours.count < 2
    end
  end
end

describe "The Game of Life" do
  describe "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    it "cells with 1 neighbour dies in the next day" do
      world = World.new
      world.create_cell(Cell.new(1,1))
      world.create_cell(Cell.new(2,1))

      world.rotate!

      world.cells.each do |cell|
        cell.alive?.must_equal false
      end
    end
  end
end

describe World do
  it "should have a collection of cells" do
    world = World.new
    world.cells.wont_be_nil
  end

  it "should be able to create cells" do
    world = World.new

    random_x = rand(11)
    random_y = rand(11)
    cell = Cell.new(random_x,random_y)

    world.create_cell(cell)
    world.cells.must_include(cell)
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


