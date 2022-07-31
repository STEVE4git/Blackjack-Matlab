function cashout(user,fig1,chip_val,pix_ss,scale_font)
% cashout is called upon confirming that the user wants to exit the game
% cashout displays the users current money added to their chips
% This is called by the "Cashout and Exit" button during gameplay. Confirmation generates a
% screen displaying the users balance
% ending the game.
%   Input argument:
%       user -> The user struct that stores all of the users data.
%       fig1 -> Handle to our current figure
%       chip_val -> Value of each chip
%       pix_ss -> The Users screen size
%       scale_font -> The font scaling percentage based on the users screen
%   Output arguments
%       None

% This displays our end screen
uiimage(fig1, 'Position', pix_ss,'ImageSource','blackjack\backgrounds\victory_screen.jpg');
% Label that tells the user what the value means
uilabel(fig1, 'Position', [pix_ss(3)*.05 pix_ss(4)*.5 pix_ss(3)*.6 pix_ss(4)*.2],               ...
    'HorizontalAlignment', 'center',            ...
    'FontSize', 36*scale_font,...
    'fontweight', 'bold',...
    'BackgroundColor', [0.1 0.1 0.1],...
    'FontColor', [.15 .7 0], 'Text', "You ended the game with $");
% This UIfigure uses the users screen resolution to appropriately draw the users current cash at the upper left-hand corner
uieditfield(fig1, 'numeric',               ...
    'Editable', 'off',                           ... % This property turns off the users ability to edit this value as it is edited by the program
    'ValueDisplayFormat', '%9.2f',               ... % This displays the users current money (user.money) up to 9 digits and 2 decimal places
    'FontSize', 36*scale_font,                              ...
    'BackgroundColor', [0.01 0.01 0.01],...
    'FontColor', [.15 .7 0],                     ... % This sets the font color to green
    'HorizontalAlignment', 'center',             ...
    'fontweight', 'bold', ...
    'Position', [pix_ss(3)*.65 pix_ss(4)*.5 pix_ss(3)*.3 pix_ss(4)*.2], ...
    'Value', (user.money+user.chips*chip_val+user.curr_bet*chip_val)); % The summation of all the users chips and money




end