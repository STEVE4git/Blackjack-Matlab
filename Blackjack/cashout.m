function cashout(cashout_btn,user)
% Cashout prompts users of Doge Blackjack to confirm exit upon selecting 
% "Cashout and Exit" option during gameplay. Confirmation generates a 
% uifigure (End_Fig) which displays the user's winnings or losses prior to 
% ending the game.
%   Input arguements
%       Cashout_Btn
%       Chip_Bal
%       Start_Bal
%   Output arguements
%       None

        end_fig = uifigure('Name', 'Doge Blackjack - Goodbye!',         ...
                           'Position', [450 100 650 650],               ...
                           'Color', 'black', 'Pointer', 'hand');
        %Replace this with a "You final wallet amount is: user.money!"
        % I think the doge thing is funny but Mr.Scott might not appreciate it much since this is supposed to be a serious project
        % Plus he is grading this in the mindset of "Aunt Minnie", Aunt Minnie might not appreciate the imagery as much as you.
            
        end
end