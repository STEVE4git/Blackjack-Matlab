function [user_return,goto_what_return] = cashier(user,fig1,pix_ss,chip_val,scale_font)
% cashier represents our chip buying part of the program, the user can buy chips of any amount using buttons or keyboard Input
% The 'uispinner' struct or click the 'Buy Max' button to buy the maximum amount of current chips!
%   Input arguments
%       user -> The struct containing all of the users information
%       fig1 -> Our canvas which will render all of the cashiers graphics
%       pix_ss -> The screen resolution of the user which allows us to appropriately size the buttons
%       chip_val -> The value set for the current chips
%       scale_font -> The percentage that we scale the font up or down by
%
%   Output arguments
%       user_return -> The user struct that contains all of the users information
%       fig1_return -> fig1, our canvas which is the matlab window
%       goto_what_return -> This tells the main program where to go next

clf(fig1); % This prevents rendering other functions images and starts at a blank slate

% This uiimage draws the background image to the size of the screen
uiimage(fig1, 'Position', pix_ss,'ImageSource','backgrounds\Cashier.jpg');
% Provides a label for the users current money
uilabel(fig1, 'Position', [pix_ss(3)*.01 pix_ss(4)*.65 pix_ss(3)*.1 pix_ss(4)*.05],               ...
    'HorizontalAlignment', 'center',            ...
    'FontSize', 16*scale_font,                            ...
    'FontColor', [.15 .7 0], 'Text', 'Cash   $');
% This UIfigure uses the users screen resolution to appropriately draw the users current cash at the upper left-hand corner
balance = uieditfield(fig1, 'numeric',               ...
    'Editable', 'off',                           ... % This property turns off the users ability to edit this value as it is edited by the program
    'ValueDisplayFormat', '%9.2f',               ... % This displays the users current money (user.money) up to 9 digits and 2 decimal places
    'FontSize', 16*scale_font,                              ...
    'FontColor', [.15 .7 0],                     ... % This sets the font color to green
    'HorizontalAlignment', 'center',             ...
    'BackgroundColor', [0.1 0.1 0.1],            ...
    'Position', [pix_ss(3)*.1 pix_ss(4)*.65 pix_ss(3)*.1 pix_ss(4)*.05], 'Value', user.money);

uilabel(fig1, 'Position', [pix_ss(3)*.01 pix_ss(4)*.5 pix_ss(3)*.1 pix_ss(4)*.05],               ...
    'HorizontalAlignment', 'center',            ...
    'FontSize', 16*scale_font,                            ...
    'FontColor', [.15 .7 0], 'Text', 'Current chips:');
%{
    The reason that we have to have a uieditfield and a label is due to the fact that matlabs 'uilabel' doesn't support setting the 'Value' property
    The key to these labels and values (uieditfield) is that they are consistently positioned
    Throughout this function the UI is grouped very consistently in order to be pleasing to the user
    The labels and values that represent the users current money are always in the upper left hand corner
    
%}
% Displays the users chips
chips_display = uieditfield(fig1, 'numeric',               ...
    'Editable', 'off',                           ...
    'ValueDisplayFormat', '%9.2f',               ...
    'FontSize', 16*scale_font,                              ...
    'FontColor', [.15 .7 0],                     ...
    'HorizontalAlignment', 'center',             ...
    'BackgroundColor', [0.1 0.1 0.1],            ...
    'Position', [pix_ss(3)*.1 pix_ss(4)*.5 pix_ss(3)*.1 pix_ss(4)*.05], 'Value', user.chips);
% This button allows the user to exit the game
uibutton(fig1, 'push', 'FontSize', 14*scale_font,                    ...
    'FontWeight', 'bold',              ...
    'BackgroundColor', [0.8 0.15 0.15],...
    'HorizontalAlignment', 'center', ...
    'FontColor', 'White',           ...
    'Position', [pix_ss(3)*.8 pix_ss(4)*.6 pix_ss(3)*.15 pix_ss(4)*.03],      ...
    'Text', 'CASHOUT AND EXIT',        ...
    'ButtonPushedFcn', {@exit_callback,fig1});
    function exit_callback(~,~,fig1)
        % exit_callback function brings up a dialog prompt asking if the user wants to cashout
        % Input arguments
        %       fig1 -> Handle to our current figure
        % Output arguments
        %       None

        uiconfirm(fig1, 'Do you wish to exit the game?',                ...
            'Exit', 'Icon', 'warning', 'CloseFcn',{@exit_game,fig1});
    end

    function exit_game(~,event,fig1)
        % exit_game is a callback function that checks if the user wishes to exit
        % Input arguments:
        %       Discarded
        %       event -> The callback event used to check if they selected ok
        %       fig1 -> Handle to our current figure
        % Output arguments:
        %       None

        if event.SelectedOption == "OK"

            goto_what_return = 0; % Tells the game loop in blackjack to break
            user_return = user;
            uiresume(fig1); % This is what really exits the game as it continues where 'uiwait' stopped


        end
    end

buy_chips_spnr = uispinner(fig1, 'Position', [pix_ss(3)*.8 pix_ss(4)*.5 pix_ss(3)*.15 pix_ss(4)*.07],           ...%938
    'Limits', [0 user.money/chip_val],'FontSize',16*scale_font, 'ValueChangedFcn', {@balance_changing,chips_display,balance,chip_val});
uilabel(fig1, 'HorizontalAlignment', 'center',          ...
    'VerticalAlignment', 'center','BackgroundColor', [0.1 0.1 0.1],'FontColor', [1 0.4 0.15],...
    'Position',[pix_ss(3)*.8 pix_ss(4)*.57 pix_ss(3)*.15 pix_ss(4)*.03],'FontSize',16*scale_font, ...
    'Text', '↓Type or click the buttons below to bet!↓');
    function balance_changing(buy_chips_spnr,~,chips_display,balance,chip_val)
        % balance_changing is a callback function that waits for the user to change the 'uispinner' struct
        % It sets the users balance through the 'Value' property to how much money the user would have if they bought the chips
        % it also sets the 'chips_display' property to the result of buying those chips

        % Input arguments:
        %   buy_chips_spnr -> The display that the user interacts with. This allows us to see what value the user chose
        %   chips_display -> The users current chips
        %   balance -> The balance figure that stores the users cash
        %   chip_val -> Value of a single chip
        % Output arguments:
        %   None

        % balance.Value is the UI field that contains the users 'Current Balance'
        % We set this by subtracting the amount of chips the user wants to
        % buy (Currently stored in buy_chips_spnr which is the editable UI
        % field) times the value of each chip.
        balance.Value = user.money - buy_chips_spnr.Value * chip_val;
        % chips_display is the display field of the amount of chips the
        % user currently has. This updates to reflect the current values if
        % they do go through with buying
        chips_display.Value = user.chips + buy_chips_spnr.Value;

    end
% Buy as many chips as the user can afford!
uibutton(fig1, 'push',                                        ... % The 'push' property tells matlab that the user can only click the button
    'BackgroundColor', [0.85 0.85 0.85],          ...
    'Position', [pix_ss(3)*.8 pix_ss(4)*.40 pix_ss(3)*.15 pix_ss(4)*.07],                  ...
    'FontSize', 14*scale_font, 'FontWeight', 'bold',         ...
    'VerticalAlignment', 'Center',                ...
    'FontColor', 'White', 'BackgroundColor',  [0.2 0.7 0.15],...
    'Text', 'Buy MAX chips', 'ButtonPushedfcn', {@max_chip,buy_chips_spnr,chips_display,balance,chip_val});

    function max_chip(~,~,chips_display,buy_chips_spnr,balance,chip_val)
        % max_chips is a callback function that is called when the user clicks the 'Buy MAX chips' button
        % It then sets the chips display and the balance display to the max amount the user can safely buy
        % Input arguments:
        %   chips_display -> This needs to bet set to the max value
        %   buy_chips_spnr -> The UI spinner that needs to be set
        %   balance -> The users running balance that gets changed
        %   chip_val -> The value of each individual chip
        % Output arguments:
        % None
        
        % Just gets the maximum amount of chips possible and sets the UI 
        % to reflect that
        total_amount = user.money/chip_val;
        buy_chips_spnr.Value = total_amount;
        chips_display.Value = total_amount;
        % None of this changes the real user struct, just the UI elements
        balance.Value = user.money - total_amount*chip_val;
    end

uibutton(fig1, 'push',                                       ...
    'BackgroundColor', [0.85 0.85 0.85],          ...
    'Position', [pix_ss(3)*.8 pix_ss(4)*.3 pix_ss(3)*.15 pix_ss(4)*.07],                 ...
    'FontSize', 18*scale_font, 'FontWeight', 'bold',         ...
    'FontColor', 'Black',                         ...
    'VerticalAlignment', 'Center',                ...
    'Text', "Let's Play!",                       ...
    'ButtonPushedFcn', {@update_val,buy_chips_spnr,fig1,chip_val});

    function update_val(~,~,buy_chips_spnr,fig1,chip_val)
        % update_val is a callback function that is called when the user clicks the 'Let's play' button
        % This grabs the current amount of chips the user decided to buy and sets them into the users data
        % This function will not let the user proceed if they have 0 chips due to chips being a requirement to play
        % Input arguments:
        %       buy_chips_spnr -> The clickable/typeable UIfield that stores the
        %       amount of chips the user wants to buy
        %       fig1 -> Handle to our current figure
        %       chip_val -> Value of a single chip
        % Output arguments:
        %       None

        % These need to be temporary values to prevent chaos if the user
        % decides to not buy anything
        temp_chips = user.chips + buy_chips_spnr.Value;
        temp_money = user.money - chip_val*buy_chips_spnr.Value;
        % If these values are bogos (aka the user tries to buy 0 chips)
        % it won't go through and they're discarded

        % 0.1 was chosen as the minimum amount of buyable chips for many reasons
        % First is that any smaller than this becomes hard to type
        % If poor aunt minnie winds up with .00000003256 chips she has to
        % type all of those decimal places in or just go in all.
        % Second is that it prevents scary floating point math errors where
        % numbers get so small that the computer has to truncate to
        % represent it. It prevents alot of sketchiness and keeps the user
        % in mind.
        if temp_chips >= 0.1
            % At this point the values are set and they're real
            user.chips = temp_chips;
            user.money = temp_money;
            user_return = user; % Returns the modified user struct
            goto_what_return = 2; % Tells the game loop to go to 'the_table'
            uiresume(fig1); % Ends the function and returns to the game loop by resuming where uiwait is

        else
            % A bogos value has been entered! Minorly inconvience them by
            % making them click a button and continue!
            uiconfirm(fig1,'You cannot buy less than .1 chip! Press any button to continue!',"I'm the only one allowed to order negative items!");

        end
    end
uiwait(fig1);
end