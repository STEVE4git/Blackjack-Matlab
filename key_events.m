function n =  key_events(src,event)
  %key events decodes the user inputs from keyboard
  %input arguments
  %src - callback function
  %event - callback function
  %output arguments
  %quitgame - sets quitgame to true if user wants to quit game
global quitgame = false;
switch  event.key
  case 'q'
    quitgame = true;
  end
  end
