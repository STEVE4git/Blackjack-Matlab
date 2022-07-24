function [] =  key_events(~,event)
  %key events decodes the user inputs from keyboard
  %input arguments
  %event - callback function
  %output arguments
 
  k = lower(event.Key);
 switch k
            case 'return'
            bet_string('yes'); %returns true if user wants to enter game

            case 'yes'      %user hits yes for  buying chips and stores the value in bet
            bet = scene.Key;
            prompt_bet(bet)

            case 'no'      %user hits no to change his bets
            bet_string('no')
            
            case 'escape'
            quit_game(true)

            otherwise   %return false if wrong key is pressed
            enter_game(false);
            quit_game(false);



end

end
