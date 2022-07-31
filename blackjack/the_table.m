function [user_return,goto_what] = the_table(user,fig1,pix_ss,scale_font)
% the_table is a function that allows the user to bet at a blackjack table
% the_table renders its own background on fig1 and allows the user many methods of betting chips through matlab UI
%   Input arguments
%      user -> The users current data
%      chip_val -> The cost of a single chip
%      fig1 -> The current canvas the UI will be rendered on
%   Output arguments
%       user_return -> Returns modified user data
%       fig1_return -> Returns the modified figure

uiimage(fig1, 'BackgroundColor', 'Black','Position', pix_ss,'ImageSource','backgrounds\Main.jpeg');

% balance appears in top left corner
% balance label
uilabel(fig1, 'Position', [pix_ss(3)*.05 pix_ss(4)*.7 pix_ss(3)*.1 pix_ss(4)*.03],             ...
    'HorizontalAlignment', 'center',            ...
    'FontSize', 16*scale_font, ...
    'FontColor', [.15 .7 0], 'Text', 'Balance  $');

% Balance value
uieditfield(fig1, 'numeric',               ...
    'Editable', 'off',                           ...
    'ValueDisplayFormat', '%9.2f',               ...
    'FontSize', 16*scale_font,                              ...
    'FontColor', [.15 .7 0],                     ...
    'HorizontalAlignment', 'center',             ...
    'BackgroundColor', [0.1 0.1 0.1],            ...
    'Position', [pix_ss(3)*.15 pix_ss(4)*.7 pix_ss(3)*.1 pix_ss(4)*.03], 'Value', user.money);


% Chip label
uilabel(fig1, 'HorizontalAlignment', 'center',             ...
    'FontSize', 16*scale_font,                               ...
    'FontColor', [.8 .8 .8],                      ...
    'Position', [pix_ss(3)*.05 pix_ss(4)*.6 pix_ss(3)*.1 pix_ss(4)*.03],                  ...
    'Text', 'Chips');

% Chip quantity owned
chip_qty = uieditfield(fig1, 'numeric',         ...
    'ValueDisplayFormat', '%5.2f',         ...
    'Editable', 'off',                     ...
    'Position', [pix_ss(3)*.15 pix_ss(4)*.6 pix_ss(3)*.1 pix_ss(4)*.03],           ...
    'HorizontalAlignment', 'center',       ...
    'BackgroundColor', [0.1 0.1 0.1],      ...
    'FontSize', 16*scale_font,                        ...
    'FontColor', [.8 .8 .8],               ...
    'Value', user.chips);

cashout_btn = uibutton(fig1, 'push', 'FontSize', 16*scale_font,                    ...
    'FontWeight', 'bold',              ...
    'BackgroundColor', [0.15 0.15 0.15],...
    'HorizontalAlignment', 'center', ...
    'FontColor', [.15 .7 0],           ...
    'Position', [pix_ss(3)*.08 pix_ss(4)*.5 pix_ss(3)*.17 pix_ss(4)*.03],      ...
    'Text', 'CASHOUT AND EXIT',        ...
    'ButtonPushedFcn', {@exit_callback,fig1});
    function exit_callback(~,~,fig1)
        % exit_callback function brings up a dialog prompt asking if the user wants to cashout
        % Input arguments:
        %       None
        % Output arguments:
        %       None

        uiconfirm(fig1, 'Do you wish to exit the game?',                ...
            'Exit', 'Icon', 'warning', 'CloseFcn',{@exit_game,fig1});
    end

    function exit_game(~,event,fig1)
        % exit_game is a callback function that checks if the user wishes to exit
        % Input arguments:
        %       Discarded
        %       event -> The callback event used to check if they selected ok
        % Output arguments:
        %       None

        if event.SelectedOption == "OK"

            goto_what = 0;
            user_return = user;
            uiresume(fig1);


        end
    end


%       Betting
current_bet_label = uilabel(fig1, 'HorizontalAlignment', 'center',      ...
    'VerticalAlignment', 'center', 'Fontsize',16*scale_font, ...
    'FontColor', [1 0.4 0.15], 'Position',...
    [pix_ss(3)*.05 pix_ss(4)*.4 pix_ss(3)*0.1 pix_ss(4)*.03], 'Text', 'Current Bet');


bet_spinner = uispinner(fig1, 'Position', [pix_ss(3)*.15 pix_ss(4)*.4 pix_ss(3)*0.1 pix_ss(4)*.03],           ...
    'Limits', [0 user.chips],'BackgroundColor', [0.1 0.1 0.1], 'FontColor', [1 0.4 0.15],'Visible','on','FontSize',16*scale_font, 'ValueChangedFcn', {@start_betting,chip_qty});
uilabel(fig1, 'HorizontalAlignment', 'center',          ...
    'VerticalAlignment', 'center','BackgroundColor', [0.1 0.1 0.1],'FontColor', [1 0.4 0.15],...
    'Position',[pix_ss(3)*.08 pix_ss(4)*.45 pix_ss(3)*.17 pix_ss(4)*.03],'FontSize',16*scale_font, ...
    'Text', '↓Type or click the buttons below to bet!↓');
all_in_button = uibutton(fig1, 'push',                                        ... % The 'push' property tells matlab that the user can only click the button
    'BackgroundColor', [0.85 0.85 0.85],          ...
    'Position', [pix_ss(3)*.08 pix_ss(4)*.34 pix_ss(3)*.1 pix_ss(4)*.03],                  ...
    'FontSize', 14*scale_font, 'FontWeight', 'bold',         ...
    'VerticalAlignment', 'Center',                ...
    'FontColor', 'White', 'BackgroundColor', '#73d12e',...
    'Visible','on',...
    'Text', 'Go ALL IN!', 'ButtonPushedfcn', {@max_bet,bet_spinner,chip_qty});

    function max_bet(~,~,bet_spinner,chip_qty)
        % max_chips is a callback function that is called when the user clicks the 'Buy MAX chips' button
        % It divides the users money by the chip value and truncates it using the floor function
        % It then sets the chips display and the balance display to the max amount the user can safely buy
        % Input arguments:
        % Discarded
        % Output arguments:
        % None
        bet_spinner.Value = user.chips;
        chip_qty.Value = 0;

    end


    function start_betting(bet_spinner,~,chip_qty)
        % start_betting is a callback function that is called when the user interact with the 'bet_spinner'
        % It sets the users chip quantity, and temporary chips to the value requests within a Limits
        % Input arguments:
        %       bet_spinner -> The bet_spinner object passed through the callback function
        %       Discarded
        % Output arguments:
        %       None
        chip_qty.Value = user.chips - bet_spinner.Value;

    end


uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
    'FontSize', 16*scale_font, 'FontWeight', 'bold',         ...
    'Position', [pix_ss(3)*.08 pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.03], 'Text', 'DEAL EM!', ...
    'ButtonPushedFcn', {@deal_lim, cashout_btn,current_bet_label,bet_spinner,all_in_button,fig1});

    function deal_lim(deal_btn,~,cashout_btn,current_bet_label,bet_spinner,all_in_button,fig1)
        % deal_lim is a callback function that is called when the user interacts with the 'DEAL EM' button
        % It checks the users bet validity, and if it is above 0 the values are set and the game begins
        % Input Arguments:
        %       deal_btn -> The button object
        %       Discarded
        % Output Arguments:
        %   Nothing
        if bet_spinner.Value >= 0.1
            user.chips = user.chips - bet_spinner.Value;
            user.curr_bet = bet_spinner.Value;
            user_return = user;

            deal_btn.Visible = 'off';
            cashout_btn.Visible = 'off';
            current_bet_label.Visible = 'off';
            bet_spinner.Visible = 'off';
            all_in_button.Visible = 'off';
            goto_what = 3;
            uiresume(fig1);
        else
            uiconfirm(fig1,"You have to bet more than .1 of a chip! Press any button to continue!",'Invalid Bet!');

        end
    end
uiwait(fig1);
end
