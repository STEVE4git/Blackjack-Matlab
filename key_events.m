function n =  key_events(src,event)
  %key events decodes the user inputs from keyboard
  %input arguments
  %src - callback function
  %event - callback function
  %output arguments
  


  switch event.Key

  case 'return' %checks for return to be pressed to continue the game
  entergame = true;

  case 'q'      %checks whether the player wants to quit
  quitgame =  true;

  case (event.Key!='return') %takes the input from the screen and stores it in n
     n = event.Key;
     return ;
   end
   end
