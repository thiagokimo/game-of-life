class GameOfLifeException < StandardError ; end
class CellAlreadyExistsInTheWorldException < GameOfLifeException ; end
class CellIsAlreadyDeadException < GameOfLifeException ; end
class CellIsAlreadyAliveException < GameOfLifeException ; end
