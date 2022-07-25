function [] = Blackjack ()
% Blackjack initiates a uifigure (fig1) and displays the Doge Blackjack Main
% Menu. 
% Main Menu contains "New Game" and "Quit Game" options.
%   Input arguements:
%       None
%   Output arguements:
%       None

%--------------------------------------------------------------------------
% Generate Main Start Window
 rng('shuffle');


fig1 = uifigure('Name', 'Doge Blackjack',                               ...
                    'Position', [128 56 1280 720],                      ...
                    'Color', 'black', 'Pointer','hand', 'Visible', 'off');

%--------------------------------------------------------------------------
% Generate Main Menu background
Fig_Main = uiimage(fig1, 'Position', [250 45 750 701] );
      Fig_Main.ImageSource = 'backgrounds\Dogearspalace_animated(1).gif';

%--------------------------------------------------------------------------
% "New Game" push-button
New_Game_Btn = uibutton(fig1, 'push', 'BackgroundColor', 'Black',       ...
                             'Position', [285 200 165 45],              ...
                             'IconAlignment', 'center',                 ...
                             'Text', '',                                ...
                             'ButtonPushedFcn', @(New_Game_Btn, event)  ...
                             Begin);
      New_Game_Btn.Icon = 'buttons\newgame.png';

    function Begin(New_Game_Btn)
    close(fig1);
    user = struct('chips',0,'money',5000,'card_val','0');
    Cashier(New_Game_Btn, user);
    end

%--------------------------------------------------------------------------
% "Quit" push-button
Quit_Btn = uibutton(fig1, 'push', 'BackgroundColor', 'Black',           ...
                            'Position', [285 145 165 45], 'Text', '',   ...
                            'IconAlignment', 'center',                  ...
                            'ButtonPushedFcn', @(Quit_Btn, event) Quit_Game);
      Quit_Btn.Icon='buttons\quitgame.png';

    function Quit_Game(Quit_Btn)
    close(fig1);
    end

fig1.Visible = 'on';

end