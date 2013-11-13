The Game of Life
============

Implementing Conway's Game of Life the TDD way, with Ruby :)
I used **minitest** for testing and **gosu** for displaying the game on the screen.

##Installing

To install the game, run:

  > `gem install game-of-life`

If you're using ruby 2.X, **gosu** may crash the installation because of some missing dependencies. To avoid that,
before installing the game, you must install the libraries **libogg** and **libvorbis**. If can install them with brew:

  > `brew install libogg` and `brew install libvorbis`
  
##Running the game

On your terminal, run the command:

  > `game-of-life`
