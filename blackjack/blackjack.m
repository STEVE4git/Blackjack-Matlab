function [] = blackjack ()
% Blackjack initiates a uifigure (fig1) and displays the Doge Blackjack Main
% Menu.
% Main Menu contains "New Game" and "Quit Game" options.
%   Input arguments:
%       None
%   Output arguments:
%       None

%--------------------------------------------------------------------------
% Generate Main Start Window
rng('shuffle');


fig1 = uifigure('Name', 'Blackjack',                               ...
    'Windowstate','fullscreen',                      ...
    'Color', 'black', 'Pointer','hand', 'Visible', 'off');

%--------------------------------------------------------------------------
% Generate Main Menu background
set(0,'units','pixels');
pix_ss = get(0,'screensize');
user = struct('chips',0,'money',5000,'card_val',0,'curr_bet',0);
chip_val = 50;
fig_main = uiimage(fig1, 'Position', pix_ss );
fig_main.ImageSource = 'backgrounds\main_menu_background.gif';

%--------------------------------------------------------------------------
% "New Game" push-button
new_game_btn = uibutton(fig1, 'push', 'BackgroundColor', 'Black',       ...
    'Position', [pix_ss(3)*.2 pix_ss(4)*.3 pix_ss(3)*.15 pix_ss(4)*.12],              ...
    'IconAlignment', 'center',                 ...
    'Text', '',                                ...
    'ButtonPushedFcn', @begin);
new_game_btn.Icon = 'buttons\newgame.png';

    function begin(~,~,~)
        clf(fig1);
        [user,fig1] = cashier(user,chip_val,fig1,pix_ss);
        [user,fig1] = the_table(user,fig1,pix_ss);
        [user,fig1,goto_what] = deal_cards(fig1,user,chip_val,pix_ss);
        while true
            switch goto_what
                case 1
                    [user, fig1, goto_what] = cashier(user,chip_val,fig1,pix_ss);
                case 2
                    [user,fig1] = the_table(user,fig1,pix_ss);
                    [user,fig1,goto_what] = deal_cards(fig1,user,chip_val,pix_ss);
            end
        end
    end

%--------------------------------------------------------------------------
% "Quit" push-button
quit_btn = uibutton(fig1, 'push', 'BackgroundColor', 'Black',           ...
    'Position', [pix_ss(3)*.2 pix_ss(4)*.12 pix_ss(3)*.15 pix_ss(4)*.12], 'Text', '',   ...
    'IconAlignment', 'center',                  ...
    'ButtonPushedFcn', @(quit_btn, event) quit_game);
quit_btn.Icon='buttons\quitgame.png';

    function quit_game(~)
        close(fig1);
    end

fig1.Visible = 'on';

end