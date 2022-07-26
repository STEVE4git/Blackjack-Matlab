function [user_return,fig1_return,deal_btn_return,current_bet_label_return,bet_spinner_return,cashout_btn_return] = the_table(user,chip_val,fig1,pix_ss)
% Doge_Blackjack initiates a uifigure (fig1) and the Blackjack game 
% environment. Doge_Blackjack incorporates features such as
% multiple betting options, balance tracking, restart, and cashout/exit.
%   Input arguments
%      user
%      chip_val
%      fig 1
%   Output arguments
%       None



temp_chips_bet = 0;


    % Generates Blackjack table and dealer graphics.
fig_start = uiimage(fig1, 'BackgroundColor', 'Black',                   ...
                         'Position', pix_ss);
       fig_start.ImageSource = 'backgrounds\Main.jpeg';

    % balance appears in top left corner
        % balance label
uilabel(fig1, 'Position', [120 650 125 22],             ...
                             'HorizontalAlignment', 'right',            ...
                             'FontSize', 16, ...
                        'FontColor', [.15 .7 0], 'Text', 'Balance  $');

        % Balance value
uieditfield(fig1, 'numeric',               ...
                           'Editable', 'off',                           ...
                           'ValueDisplayFormat', '%9.0f',               ...
                           'FontSize', 16,                              ...
                           'FontColor', [.15 .7 0],                     ...
                           'HorizontalAlignment', 'center',             ...
                           'BackgroundColor', [0.1 0.1 0.1],            ...
                           'Position', [250 650 86 22], 'Value', user.money);
 

    % Chip label
uilabel(fig1, 'HorizontalAlignment', 'center',             ...
                          'FontSize', 16,                               ...
                          'FontColor', [.8 .8 .8],                      ...
                          'Position', [185 615 63 22],                  ...
                          'Text', 'Chips');

    % Chip quantity owned
chip_qty = uieditfield(fig1, 'numeric',         ...
                                 'ValueDisplayFormat', '%5.0f',         ...
                                 'Editable', 'off',                     ...
                                 'Position', [250 615 86 22],           ...
                                 'HorizontalAlignment', 'center',       ...
                                 'BackgroundColor', [0.1 0.1 0.1],      ...
                                 'FontSize', 16,                        ...
                                 'FontColor', [.8 .8 .8]);
                                chip_qty.Value = user.chips;

cashout_btn = uibutton(fig1, 'push', 'FontSize', 14,                    ...
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
    
        uiconfirm(fig1, 'Do you wish to exit the game?',                ...
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
current_bet_label = uilabel(fig1, 'HorizontalAlignment', 'center',      ...
                              'VerticalAlignment', 'center', 'Fontsize',...
                              18, 'FontColor', [1 0.4 0.15], 'Position',...
                              [150 525 98 23], 'Text', 'Current Bet');                 



 bet_spinner = uispinner(fig1, 'Position', [265 525 108 24],           ...
          'Limits', [0 user.chips],'BackgroundColor', [0.1 0.1 0.1], 'FontColor', [1 0.4 0.15],'Visible','on', 'ValueChangedFcn', @(bet_spinner,event)...
            start_betting(bet_spinner));

function start_betting(bet_spinner)

chip_qty.Value = user.chips - bet_spinner.Value;
temp_chips_bet = bet_spinner.Value;

end


uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [250 375 96 30], 'Text', 'DEAL EM!', ...
                          'ButtonPushedFcn', @(deal_btn,event)         ...
                          deal_lim(deal_btn,event));

    function [] = deal_lim(deal_btn,~)
        
        if temp_chips_bet >= 1
            user.chips = user.chips - temp_chips_bet;
            user.curr_bet = temp_chips_bet;
            user_return = user;
            fig1_return = fig1;
            deal_btn_return = deal_btn;
            current_bet_label_return = current_bet_label;
            bet_spinner_return = bet_spinner;
            cashout_btn_return = cashout_btn;
            uiresume(fig1);
        else
          selection = uiconfirm(fig1,"You haven't placed a bet!'! Hit ok to place a bet or hit cancel to exit!",...
            'No Bet!');
        switch selection
            case 'OK'
            case 'Cancel'
                exit;
        end
        end
    end
 uiwait(fig1);   
end
