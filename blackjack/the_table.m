function [user_return,goto_what] = the_table(user,fig1,pix_ss,scale_font)
% the_table is a function that allows the user to bet at a blackjack table
% the_table renders its own background on fig1 and allows the user many methods of betting chips through matlab UI
%   Input arguments
%      user -> The users current data
%      chip_val -> The cost of a single chip
%      fig1 -> The current canvas the UI will be rendered on
%      pix_ss -> Stores the users screen resolution
%      scale_font -> What percentage do we use to scale the font
%   Output arguments
%       user_return -> Returns modified user data
%       goto_what -> Tells the main game loop where to go next

% Set the background of the scene
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
% This is the cashout button that users can click if they want to leave the
% game
cashout_btn = uibutton(fig1, 'push', 'FontSize', 16*scale_font,                    ...
    'FontWeight', 'bold',              ...
    'BackgroundColor', [0.8 0.15 0.15],...
    'HorizontalAlignment', 'center', ...
    'FontColor', 'White',           ...
    'Position', [pix_ss(3)*.08 pix_ss(4)*.5 pix_ss(3)*.17 pix_ss(4)*.03],      ...
    'Text', 'CASHOUT AND EXIT',        ...
    'ButtonPushedFcn', {@exit_callback,fig1});
    function exit_callback(~,~,fig1)
        % exit_callback function brings up a dialog prompt asking if the user wants to cashout
        % Input arguments:
        %       fig1
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
        %       fig1 -> A handle to our current figure
        % Output arguments:
        %       None

        if event.SelectedOption == "OK"

            goto_what = 0; % This tell the game to end the main loop and bring up the exit screen
            user_return = user; % Returns our modified user struct
            uiresume(fig1); % Resumes the UI which ends the function


        end
    end


%       Betting
current_bet_label = uilabel(fig1, 'HorizontalAlignment', 'center',      ...
    'VerticalAlignment', 'center', 'Fontsize',16*scale_font, ...
    'FontColor', [1 0.4 0.15], 'Position',...
    [pix_ss(3)*.05 pix_ss(4)*.4 pix_ss(3)*0.1 pix_ss(4)*.03], 'Text', 'Current Bet');
% This labels the UI field so the user knows what it is
uilabel(fig1, 'HorizontalAlignment', 'center',          ...
    'VerticalAlignment', 'center','BackgroundColor', [0.1 0.1 0.1],'FontColor', [1 0.4 0.15],...
    'Position',[pix_ss(3)*.08 pix_ss(4)*.45 pix_ss(3)*.17 pix_ss(4)*.03],'FontSize',16*scale_font, ...
    'Text', '↓Type or click the buttons below to bet!↓');
% This is the field where the user can type or push the buttons on the side
% to bet chips
bet_spinner = uispinner(fig1, 'Position', [pix_ss(3)*.15 pix_ss(4)*.4 pix_ss(3)*0.1 pix_ss(4)*.03],           ...
    'Limits', [0 user.chips],'BackgroundColor', [0.1 0.1 0.1], 'FontColor', [1 0.4 0.15],'Visible','on','FontSize',16*scale_font, 'ValueChangedFcn', {@start_betting,chip_qty});

% The GO ALL IN button that allows the user to risk it all!
all_in_button = uibutton(fig1, 'push',                                        ... % The 'push' property tells matlab that the user can only click the button
    'BackgroundColor', [0.85 0.85 0.85],          ...
    'Position', [pix_ss(3)*.08 pix_ss(4)*.34 pix_ss(3)*.1 pix_ss(4)*.03],                  ...
    'FontSize', 14*scale_font, 'FontWeight', 'bold',         ...
    'VerticalAlignment', 'Center',                ...
    'FontColor', 'White', 'BackgroundColor',[0.2 0.7 0.15],...
    'Visible','on',...
    'Text', 'GO ALL IN!', 'ButtonPushedfcn', {@max_bet,bet_spinner,chip_qty});

    function max_bet(~,~,bet_spinner,chip_qty)
        % max_chips is a callback function that is called when the user clicks the 'Buy MAX chips' button
        % It then sets the chips display and the balance display to the max amount the user can safely buy
        % Input arguments
        % bet_spinner -> The bet spinner that we set to the users chips
        % chip_qty -> The chip_qty that displays the users chips
        % Output arguments:
        % None
        bet_spinner.Value = user.chips; % Pretty simplistic, just set it to the users chips!
        chip_qty.Value = 0;

    end


    function start_betting(bet_spinner,~,chip_qty)
        % start_betting is a callback function that is called when the user interact with the 'bet_spinner'
        % It sets the users chip quantity, and temporary chips to the value requests within a Limits
        % Input arguments:
        %       bet_spinner -> The bet_spinner object passed through the callback function
        %       Discarded
        %       chip_qty -> The display of our current chips
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
        %       deal_btn -> The handle to the deal_btn
        %       Discarded
        %       cashout_btn -> The handle to the cashout_btn
        %       current_bet_label -> The handle to the bet label
        %       bet_spinner -> The handle to the bet_spinner
        %       all_in_button -> The handle to the all in button
        %       fig1 -> Handle to the main figure
        % Output Arguments:
        %   Nothing

        % Checks to be sure it's a valid bet!
        if bet_spinner.Value >= 0.1
            % This subtracts the users current bet, and sets the users
            % current bet to the amount of chips they bought
            user.chips = user.chips - bet_spinner.Value;
            user.curr_bet = bet_spinner.Value;
            % Return our modified struct
            user_return = user;

            % Hides unneeded buttons since we're going to a new scene!
            deal_btn.Visible = 'off';
            cashout_btn.Visible = 'off';
            current_bet_label.Visible = 'off';
            bet_spinner.Visible = 'off';
            all_in_button.Visible = 'off';

            goto_what = 3; % This tells the program we want to go to 'deal_cards' aka 3
            uiresume(fig1); % Resumes the UI to end the function
        else % They're trying to bet 0 or negative chips! Stop them!
            uiconfirm(fig1,"You have to bet more than .1 of a chip! Press any button to continue!",'Invalid Bet!');

        end
    end
uiwait(fig1); % This has to be used to prevent the function from ending instantly and destroying our UI
end