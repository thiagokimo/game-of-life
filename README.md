The Game of Life
============
![pictureGallery](https://lh4.googleusercontent.com/-1vaiRa4FP6Y/UpOhsmoFtDI/AAAAAAAABbY/WlEbsDYOpMA/w804-h622-no/gol.png "screenshot")

This is an implementation of [Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life "Conway's Game of Life") the TDD way, with Ruby :)

I used **minitest** for testing and **gosu** to display the game on the screen.

##Installing

To install the game, run:

  > `gem install game-of-life`

If you're using ruby 2.X, **gosu** may crash the installation because of some missing dependencies. To avoid that,
before installing the game, you must install the libraries **libogg** and **libvorbis**. You can install them with brew:

  > `brew install libogg` and `brew install libvorbis`
  
##Running the game

On your terminal, run the command:

  > `game-of-life`

Have fun!
