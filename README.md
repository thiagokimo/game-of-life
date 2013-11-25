The Game of Life
============
![pictureGallery](https://photos-6.dropbox.com/t/0/AAB02tDagfMJ1zFpXa5UACS2oBrUOaqmtg_NbuhuBPk6gA/12/6313549/png/1024x768/3/1384398000/0/2/Screenshot%202013-11-13%2023.36.31.png/WNPIItGnmaZN0dGKymEGVoa2u1Qp7w_UKbk2UDutBYU "screenshot")

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
