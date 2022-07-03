
%There will need to be a variable for coordinating keyboard events between scenes

function n =  key_events(current_scene) %This is completely wrong btw, https://www.mathworks.com/help/matlab/ref/waitforbuttonpress.html 
  %key events decodes the user inputs from keyboard
  %input arguments
  %src - callback function
  %event - callback function
  %output arguments
  %quitgame - sets quitgame to true if user wants to quit game
switch current_scene   %This can be added at any time I guess where q will bring up the exit screen
  case 0
    n = key_enter_game() %This is pseudocode you will need to write these functions yourself 
   case 1
   n = buy_chips() %This will return the amount of chips the user should buy
   case 2
   n = parse_user_input() %this will return what option the user picked (hit, stand etc)
   case 3
    result = render_exit_game(); % This will change the scene and prompt the user if they want to leave. Graphics render will change scenes. It returns true if we leave the game
    if result == true
        exit;
  end
  end


%While I'm here I will lay out some guidelines for what keyevents should do:
% Key events will handle chip betting through the chip betting menu
% There will be multiple scenes based on the users progression through the game. Currently there will be at least: Main-menu, Casino, chip-buying, betting table, endscreen. More detail will come from more work
% You need to create functions for atleast those things processing user input (such as when the user hits enter) enter the game. If the user hits s they 'stand' or if the user types h they 'hit'
%This will all be coordinated through your main function. The scene will be passed through the function args and you will call your own function to return a result based on the scene