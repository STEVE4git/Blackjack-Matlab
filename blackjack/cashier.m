function [user_return,goto_what_return] = cashier(user,chip_val,fig1,pix_ss)
% cashier represents our chip buying part of the program, the user can buy chips of any amount using buttons or keyboard Input
% The 'uispinner' struct or click the 'Buy Max' button to buy the maximum amount of current chips!
%   Input arguments
%       user -> The struct containing all of the users information
%       chip_val -> The value set for the current chips
%       fig1 -> Our canvas which will render all of the cashiers graphics
%       pix_ss -> The screen resolution of the user which allows us to appropriately size the buttons
%   Output arguments
%       user_return -> The user struct that contains all of the users information
%       fig1_return -> fig1, our canvas which is the matlab window
%       goto_what_return -> This tells the main program where to go next

clf(fig1); % This prevents rendering other functions images and starts at a blank slate
uiimage(fig1, 'Position', pix_ss,'ImageSource','backgrounds\Cashier.jpg' );
%{ 
    cashier_fig is similar to the background you saw in the main menu
    It draws the background image 'Cashier.jpg' to the size of the screen
    
%}
uilabel(fig1, 'Position', [pix_ss(3)*.07 pix_ss(4)*.65 pix_ss(4)*.1 pix_ss(4)*.05],               ...
    'HorizontalAlignment', 'center',            ...
    'FontSize', 16,                            ...
    'FontColor', [.15 .7 0], 'Text', 'Cash   $');
% This UIfigure uses the users screen resolution to appropriately draw the users current cash at the upper left-hand corner
balance = uieditfield(fig1, 'numeric',               ...
    'Editable', 'off',                           ... % This property turns off the users ability to edit this value as it is edited by the program
    'ValueDisplayFormat', '%9.2f',               ... % This displays the users current money (user.money) up to 9 digits and 2 decimal places
    'FontSize', 16,                              ... 
    'FontColor', [.15 .7 0],                     ... % This sets the font color to green
    'HorizontalAlignment', 'center',             ...
    'BackgroundColor', [0.1 0.1 0.1],            ... 
    'Position', [pix_ss(3)*.15 pix_ss(4)*.65 pix_ss(4)*.1 pix_ss(4)*.05], 'Value', user.money);

uilabel(fig1, 'Position', [pix_ss(3)*.07 pix_ss(4)*.5 pix_ss(4)*.1 pix_ss(4)*.05],               ...
    'HorizontalAlignment', 'center',            ...
    'FontSize', 16,                            ...
    'FontColor', [.15 .7 0], 'Text', 'Current chips:');
%{
    The reason that we have to have a uieditfield and a label is due to the fact that matlabs 'uilabel' doesn't support setting the 'Value' property
    The key to these labels and values (uieditfield) is that they are consistently positioned
    Throughout this function the UI is grouped very consistently in order to be pleasing to the user
    The labels and values that represent the users current money are always in the upper left hand corner
    
%}

chips_display = uieditfield(fig1, 'numeric',               ...
    'Editable', 'off',                           ...
    'ValueDisplayFormat', '%9.2f',               ...
    'FontSize', 16,                              ...
    'FontColor', [.15 .7 0],                     ...
    'HorizontalAlignment', 'center',             ...
    'BackgroundColor', [0.1 0.1 0.1],            ...
    'Position', [pix_ss(3)*.15 pix_ss(4)*.5 pix_ss(4)*.1 pix_ss(4)*.05], 'Value', user.chips);

buy_chips_spnr = uispinner(fig1, 'Position', [pix_ss(3)*.8 pix_ss(4)*.5 pix_ss(4)*.15 pix_ss(4)*.07],           ...%938
    'Limits', [0 user.money/chip_val], 'ValueChangedFcn', @balance_changing);

    function balance_changing(buy_chips_spnr,~)
    % balance_changing is a callback function that waits for the user to change the 'uispinner' struct
    % It sets the users balance through the 'Value' property to how much money the user would have if they bought the chips
    % it also sets the 'chips_display' property to the result of buying those chips
  
    % Input arguments:
    %   buy_chips_spnr -> The display that the user interacts with. This allows us to see what value the user chose
    %   ~ -> Discarded argument to prevent waste
    % Output arguments:
    %   None

        balance.Value = user.money - buy_chips_spnr.Value * chip_val;
        chips_display.Value = user.chips + buy_chips_spnr.Value;
    end

uibutton(fig1, 'push',                                        ... % The 'push' property tells matlab that the user can only click the button
    'BackgroundColor', [0.85 0.85 0.85],          ...
    'Position', [pix_ss(3)*.8 pix_ss(4)*.40 pix_ss(4)*.15 pix_ss(4)*.07],                  ...
    'FontSize', 14, 'FontWeight', 'bold',         ...
    'VerticalAlignment', 'Center',                ...
    'FontColor', 'White', 'BackgroundColor', '#73d12e',...
    'Text', 'Buy MAX chips', 'ButtonPushedfcn', @max_chip);

    function max_chip(~,~)
    % max_chips is a callback function that is called when the user clicks the 'Buy MAX chips' button
    % It divides the users money by the chip value and truncates it using the floor function
    % It then sets the chips display and the balance display to the max amount the user can safely buy
    % Input arguments:
    % Discarded
    % Output arguments:
    % None
        total_amount = user.money/chip_val;
        buy_chips_spnr.Value = total_amount;
        chips_display.Value = total_amount;
        
        balance.Value = user.money - total_amount*chip_val;
    end

uibutton(fig1, 'push',                                       ...
    'BackgroundColor', [0.85 0.85 0.85],          ...
    'Position', [pix_ss(3)*.8 pix_ss(4)*.3 pix_ss(4)*.15 pix_ss(4)*.07],                 ...
    'FontSize', 14, 'FontWeight', 'bold',         ...
    'FontColor', 'Black',                         ...
    'VerticalAlignment', 'Center',                ...
    'Text', "Let's Play!",                       ...
    'ButtonPushedFcn', @update_val);

    function update_val(~,~)
    % update_val is a callback function that is called when the user clicks the 'Let's play' button
    % This grabs the current amount of chips the user decided to buy and sets them into the users data
    % This function will not let the user proceed if they have 0 chips due to chips being a requirement to play
    % Input arguments:
    % Discarded
    % Output arguments:
    % None
        user.chips = user.chips + buy_chips_spnr.Value;
        user.money = user.money - chip_val*buy_chips_spnr.Value;
        
        if user.chips > 0.1
            user_return = user;
            goto_what_return = 2;
            uiresume(fig1);
            
        else
            selection = uiconfirm(fig1,'You cannot buy less than 1 chip! Hit ok to buy chips or hit cancel to end the game!',...
                'No Chips!');
            switch selection
                case 'OK'
                case 'Cancel'
                    exit;
            end
        end
    end
uiwait(fig1);
end