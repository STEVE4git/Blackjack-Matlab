function Cashout(Cashout_Btn, Chip_Bal, Start_Bal)
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

        End_Fig = uifigure('Name', 'Doge Blackjack - Goodbye!',         ...
                           'Position', [450 100 650 650],               ...
                           'Color', 'black', 'Pointer', 'hand');

        if Chip_Bal > Start_Bal
            Congrats_Fig = uiimage(End_Fig, 'Position', [35 175 575 440]);
            Congrats_Fig.ImageSource = 'backgrounds\GET_MONEY.gif';

        elseif Chip_Bal <= Start_Bal
            Sorry_Fig = uiimage(End_Fig, 'position', [35 175 575 440]);
            Sorry_Fig.ImageSource = 'backgrounds\poor.jpg';
            
        end
end