function [] = blackjack ()
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
fig_main = uiimage(fig1, 'Position', [250 45 750 701] );
      fig_main.ImageSource = 'backgrounds\Dogearspalace_animated(1).gif';

%--------------------------------------------------------------------------
% "New Game" push-button
new_game_btn = uibutton(fig1, 'push', 'BackgroundColor', 'Black',       ...
                             'Position', [285 200 165 45],              ...
                             'IconAlignment', 'center',                 ...
                             'Text', '',                                ...
                             'ButtonPushedFcn', @(new_game_btn, event)  ...
                             begin);
      new_game_btn.Icon = 'buttons\newgame.png';

    function begin(new_game_btn)
    close(fig1);
    user = struct('chips',0,'money',5000,'card_val',0,'curr_bet',0);
    chip_val = 50;
    cashier(user,chip_val);
    end

%--------------------------------------------------------------------------
% "Quit" push-button
quit_btn = uibutton(fig1, 'push', 'BackgroundColor', 'Black',           ...
                            'Position', [285 145 165 45], 'Text', '',   ...
                            'IconAlignment', 'center',                  ...
                            'ButtonPushedFcn', @(quit_btn, event) quit_game);
      quit_btn.Icon='buttons\quitgame.png';

    function quit_game(quit_btn)
    close(fig1);
    end

fig1.Visible = 'on';

end