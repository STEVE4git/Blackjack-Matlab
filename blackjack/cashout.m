function cashout(cashout_btn,~,user)
% cashout is called upon confirming that the user wants to exit the game
% cashout displays the users current money added to their chips
% This is called by the "Cashout and Exit" button during gameplay. Confirmation generates a
% screen displaying the users balance
% ending the game.
%   Input argument:
%       cashout_btn -> The button that is passed by the callback
%       Discarded
%       user -> The users current data
%   Output arguments
%       None

end_fig = uifigure('Name', 'Blackjack - Goodbye!',         ...
    'WindowState','fullscreen',                ...
    'Color', 'black', 'Pointer', 'hand');
%Replace this with a "You final wallet amount is: user.money!"
% I think the doge thing is funny but Mr.Scott might not appreciate it much since this is supposed to be a serious project
% Plus he is grading this in the mindset of "Aunt Minnie", Aunt Minnie might not appreciate the imagery as much as you.

end