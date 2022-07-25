function [] = the_table(user,chip_val)
% Doge_Blackjack initiates a uifigure (fig3) and the Blackjack game 
% environment. Doge_Blackjack incorporates features such as
% multiple betting options, balance tracking, restart, and cashout/exit.
%   Input arguments
%      user
%      chip_val
%   Output arguments
%       None



temp_chips_bet = 0;

fig3 = uifigure('Name', 'Doge Blackjack',                               ...
                    'Position', [128 56 1280 720],                      ...
                    'Color', 'black', 'Pointer','hand', 'Visible', 'on');

    % Generates Blackjack table and dealer graphics.
fig_start = uiimage(fig3, 'BackgroundColor', 'Black',                   ...
                         'Position', [0 0 1280 720]);
       fig_start.ImageSource = 'backgrounds\Main.jpeg';

    % balance appears in top left corner
        % balance label
balance_label = uilabel(fig3, 'Position', [120 650 125 22],             ...
                             'HorizontalAlignment', 'right',            ...
                             'FontSize', 16, ...
                        'FontColor', [.15 .7 0], 'Text', 'Balance  $');

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
    function exit
    %exit function exit's the user out of the game
    %Input arguments none
    %Output arguments none
    
        uiconfirm(fig3, 'Do you wish to exit the game?',                ...
                    'Exit', 'Icon', 'warning', 'CloseFcn', @exit_game);
    end

    function exit_game(~, event)
    % exit_game checks for mouse click
    % Input arguments 
    % src - callback function
    % event - callback function
    % Output arguments - none
        if event.SelectedOption == "OK"
            cashout(cashout_btn,user);
        end
    end


%       Betting
current_bet_label = uilabel(fig3, 'HorizontalAlignment', 'center',      ...
                              'VerticalAlignment', 'center', 'Fontsize',...
                              18, 'FontColor', [1 0.4 0.15], 'Position',...
                              [150 525 98 23], 'Text', 'Current Bet');                 



 bet_spinner = uispinner(fig3, 'Position', [265 525 108 24],           ...
          'Limits', [0 user.chips],'BackgroundColor', [0.1 0.1 0.1], 'FontColor', [1 0.4 0.15],'Visible','on', 'ValueChangedFcn', @(bet_spinner,event)...
            start_betting(bet_spinner));

function start_betting(bet_spinner)

chip_qty.Value = user.chips - bet_spinner.Value;
temp_chips_bet = bet_spinner.Value;

end


deal_btn = uibutton(fig3, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [250 375 96 30], 'Text', 'DEAL EM!', ...
                          'ButtonPushedFcn', @(deal_btn,event)         ...
                          deal_lim(deal_btn,event));

    function [] = deal_lim(deal_btn,~)
        if temp_chips_bet > 0
            user.chips = user.chips - temp_chips_bet;
            user.curr_bet = temp_chips_bet;
            user = deal_cards(deal_btn,current_bet_label,bet_spinner,cashout_btn, fig3,user,chip_val);
            close(fig3);
            restart_game = uifigure('Name', 'Hand has ended!',                               ...
                    'Position', [128 56 1280 720],                      ...
                    'Color', 'black', 'Pointer','hand', 'Visible', 'on');
           if 0 < user.money      
           goto_cashier = uibutton(restart_game, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [200 375 300 30], 'Text', 'Want to buy more chips?', ...
                          'ButtonPushedFcn', {@call_cashier,restart_game});
           end
            if 0 < user.chips
            goto_table =  uibutton(restart_game, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [600 375 250 30], 'Text', 'Want to play again?', ...
                          'ButtonPushedFcn', {@call_table,restart_game});
            end      
                         

            quit =  uibutton(restart_game, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [100 375 100 30], 'Text', 'Exit', ...
                          'ButtonPushedFcn', @quit_game);
                        
        
          else
           selection = uiconfirm(fig3,"You haven't placed a bet!'! Hit ok to place a bet or hit cancel to exit!",...
            'No Bet!');
        switch selection
            case 'OK'
            case 'Cancel'
                exit;
        end


        end
    end
       function call_cashier(~,~,restart_game)
           close(restart_game);
                cashier(user,chip_val);
        
               
       end
        function call_table(~,~,restart_game)
                   close(restart_game);
                  the_table(user,chip_val);
              end
  function quit_game(~,~)
                          exit;
                          end
    
end
