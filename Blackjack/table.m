function [] = table(user,chip_val)
% Doge_Blackjack initiates a uifigure (fig3) and the Blackjack game 
% environment. Doge_Blackjack incorporates features such as
% multiple betting options, balance tracking, restart, and cashout/exit.
%   Input arguements
%      user
%   Output arguements
%       None



temp_chips_bet = 0;

fig3 = uifigure('Name', 'Doge Blackjack',                               ...
                    'Position', [128 56 1280 720],                      ...
                    'Color', 'black', 'Pointer','hand', 'Visible', 'off');

    % Generates Blackjack table and dealer graphics.
fig_start = uiimage(fig3, 'BackgroundColor', 'Black',                   ...
                         'Position', [0 0 1280 720]);
       fig_start.ImageSource = 'backgrounds\Main.jpeg';

    % balance appears in top left corner
        % balance label
balance_label = uilabel(fig3, 'Position', [120 650 125 22],             ...
                             'HorizontalAlignment', 'right',            ...
                             'FontSize', 16, ...
                        'FontColor', [.15 .7 0], 'Text', 'Chips Balance  $');

        % Balance value
balance = uieditfield(fig3, 'numeric', 'Limits', [0 Inf],               ...
                           'Editable', 'off',                           ...
                           'ValueDisplayFormat', '%9.0f',               ...
                           'FontSize', 16,                              ...
                           'FontColor', [.15 .7 0],                     ...
                           'HorizontalAlignment', 'center',             ...
                           'BackgroundColor', [0.1 0.1 0.1],            ...
                           'Position', [250 650 86 22], 'Value', user.money);
 

    % Chip label
chip_label = uilabel(fig3, 'HorizontalAlignment', 'center',             ...
                          'FontSize', 16,                               ...
                          'FontColor', [.8 .8 .8],                      ...
                          'Position', [185 615 63 22],                  ...
                          'Text', 'Chips');

    % Chip quantity owned
chip_qty = uieditfield(fig3, 'numeric', 'Limits', [0 Inf],         ...
                                 'ValueDisplayFormat', '%5.0f',         ...
                                 'Editable', 'off',                     ...
                                 'Position', [250 615 86 22],           ...
                                 'HorizontalAlignment', 'center',       ...
                                 'BackgroundColor', [0.1 0.1 0.1],      ...
                                 'FontSize', 16,                        ...
                                 'FontColor', [.8 .8 .8]);
                                chip_qty.Value = user.chips;

cashout_btn = uibutton(fig3, 'push', 'FontSize', 14,                    ...
                                     'FontWeight', 'bold',              ...
                                    'BackgroundColor', [0.15 0.15 0.15],...
                                     'FontColor', [.15 .7 0],           ...
                                     'Position', [350 649 150 26],      ...
                                     'Text', 'CASHOUT AND EXIT',        ...
                                'ButtonPushedFcn', @(cashout_btn, event)...
                                 exit());
    function [] = exit()
        uiconfirm(fig3, 'Do you wish to exit the game?',                ...
                    'Exit', 'Icon', 'warning', 'CloseFcn', @exit_game);
    end

    function exit_game(src, event)
        if event.SelectedOption == "OK"
            cashout(cashout_btn,user);
        end
    end


%       Betting
current_bet_Label = uilabel(fig3, 'HorizontalAlignment', 'center',      ...
                              'VerticalAlignment', 'center', 'Fontsize',...
                              18, 'FontColor', [1 0.4 0.15], 'Position',...
                              [150 525 98 23], 'Text', 'Current Bet');                 

%       Current Bet value displayed
current_bet = uieditfield(fig3, 'numeric', 'Limits', [0 Inf],          ...
                            'Editable', 'off', 'ValueDisplayFormat',    ...
                            '%9.0f', 'HorizontalAlignment', 'center',   ...
                            'FontSize', 18, 'FontColor', [1 0.4 0.15],  ...
                           'BackgroundColor', [0.1 0.1 0.1], 'Position',...
                            [265 525 108 24], 'Value', 0);


 bet_spinner = uispinner(fig3, 'Position', [510 218 65 22],           ...
          'Limits', [1 user.chips], 'ValueChangedFcn', @(bet_spinner,event)...
            start_betting(bet_spinner));

function start_betting(bet_spinner)

temp_chips_bet = bet_spinner.Value;
current_bet.Value = bet_spinner.Value;

end


deal_btn = uibutton(fig3, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [250 375 96 30], 'Text', 'DEAL EM!', ...
                          'ButtonPushedFcn', @(deal_btn, event)         ...
                          deal_lim(deal_btn, current_bet));

    function [] = deal_lim(deal_btn, current_bet)
        if current_bet.Value > 0
            user.chips = user.chips - temp_chips_bet*chip_val;
            user.curr_bet = current_bet.Value;
            user = deal_cards(deal_btn, balance, current_bet_Label,            ...
                    current_bet, Btn_25, Btn_50, Btn_100, Btn_500,      ...
                    Btn_1000, Clr_Bet_Btn, Restart_Btn, cashout_btn, fig3,user);
            close(fig3);
            restart_game = uifigure('Name', 'Hand has ended!',                               ...
                    'Position', [128 56 1280 720],                      ...
                    'Color', 'black', 'Pointer','hand', 'Visible', 'off');
           goto_cashier = uibutton(restart_game, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [250 375 96 30], 'Text', 'Want to buy more chips?', ...
                          'ButtonPushedFcn', @(goto_cashier, event)call_cashier(goto_cashier, event));
                          function call_cashier(deal_btn, event)
                          cashier(user);
                          end

            goto_table =  uibutton(restart_game, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [250 375 96 30], 'Text', 'Want to play again?', ...
                          'ButtonPushedFcn', @(goto_table, event)call_table(goto_table, event));
                          function call_table(goto_table, event)
                          table(user);

                          end

            quit =  uibutton(restart_game, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [250 375 96 30], 'Text', 'Exit', ...
                          'ButtonPushedFcn', @(quit, event)quit_game(quit, event));
                          function quit_game(quit, event)
                          exit;
                          end
        
          else
           selection = uiconfirm(fig2,'You haven't placed a bet!'! Hit ok to place a bet or hit cancel to end the game!',...
            'No Bet!');
        switch selection
            case 'OK'
                table(user,chip_val);
            case 'Cancel'
                exit;
        end


     end

    fig3.Visible = 'on';
end