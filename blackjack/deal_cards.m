function [user_return,goto_what] = deal_cards(user,fig1,pix_ss,chip_val,scale_font)
% deal_cards hides betting and restart options in Doge_Blackjack game
% environment upon users selecting "Deal" to indicate betting has
% concluded. The hand is initiated and cards are dealt to both the player
% and the dealer.
%   Input arguments:
%       user -> The user struct that stores the users data
%       fig1 -> The handle to the current figure
%       pix_ss -> The users current screen resolution
%       chip_val -> The value of each chip in the game
%       scale_font -> The scaling factor for the font
%   Output arguments
%       user_return -> Returns the modified users data
%       goto_what -> Returns what function should the game execute next



uilabel(fig1, 'HorizontalAlignment', 'center',          ...
    'VerticalAlignment', 'center', 'Fontsize',...
    18*scale_font, 'FontColor', [1 0.4 0.15], 'Position',...
    [pix_ss(3)*.05 pix_ss(4)*.5 pix_ss(3)*.1 pix_ss(4)*.03], 'Text', 'Pot Size  $');

uieditfield(fig1, 'numeric', 'Limits', [0 Inf],              ...
    'Editable', 'off', 'ValueDisplayFormat',    ...
    '%9.2f', 'HorizontalAlignment', 'center',   ...
    'FontSize', 18*scale_font, 'FontColor', [1 0.4 0.15],  ...
    'BackgroundColor', [0.1 0.1 0.1], 'Position',...
    [pix_ss(3)*.15 pix_ss(4)*.5 pix_ss(3)*.1 pix_ss(4)*.03], ...
    'Value', user.curr_bet * chip_val);


% dealer_card_val is sadly a nested function variable because it gets sent
% to callback functions that need to modify its value.
dealer_card_val = 0;
% hold_btn is similar, it gets hidden by a callback function and hit_btn
% needs to be able to hide itself and hold, and hold needs to be able to do
% the same thing. So one of them has to be out of scope
hold_btn = 0;
% This is our value that we use to display the dealers cards as he
% progressively draws more. They get rendered at a constant distance apart
% based off the users resolution
dealer_x = pix_ss(3)*.025;
% A simple 'boolean' to prevent us from rendering the hit and hold buttons
% if the inital deal ended the hand
did_inital_deal_end = 0;
% This is the users version of dealer_x, sadly we can't use the same
% variable because they get modified differently. (The dealer_x gets
% modified during the dealers turn and 'x' gets modified during the hit)
x = pix_ss(3)*.025;
% This renders out the users first card. The position is chosen to be the
% center of the screen and the difference between the dealer and the users
% location is that the dealer (due to him being visually higher on the
% screen) also has his cards rendered higher on the screen
% Since user.card_val is zero at first you can just drop whatever value
% cards spits out right into it!
card_1 = uiimage(fig1, 'Position', [pix_ss(3)*.45 pix_ss(4)*.03 pix_ss(3)*.1 pix_ss(4)*.14]);
[card_1.ImageSource, user.card_val] = cards;
% This is a very neat variable due to the requriements of the game
% Since we're playing on soft aces we have to keep track if the user landed
% a ace in the first hand. Since there can never be two full value aces in
% a game this will only ever be 0/1. Later on, if the user goes Bust this
% gets checked to prevent the user from going bust if they have a full ace
% in their deck. Since it also gets modified in a callback it has to be
% declared out of scope.
full_aces = 0;

% Due to the requirements of blackjack the dealer gets his second card face
% down. We still keep the string because we want to show the dealers cards
% at the end of the hand to make sure he isn't cheating!
card_2 = uiimage(fig1, 'Position', [pix_ss(3)*.45 pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.14]);
card_2.ImageSource = 'b1fv.gif';

[card_2_render_string,dealer_card_val] = cards;

% This is the last card the user draws for the initial hand.
% We also have to check and be sure that if the user landed two aces that
% they get treated appropriately, and if they landed a single ace it can be
% treated as a '1' later in the game rather than an 11
card_3 = uiimage(fig1, 'Position', [pix_ss(3)*.45+x pix_ss(4)*.03 pix_ss(3)*.1 pix_ss(4)*.14]);
[card_3.ImageSource, init_temp_val] = cards;
if user.card_val == 11 && init_temp_val == 11
    full_aces = 1;
    init_temp_val = 1;
elseif user.card_val == 11 || init_temp_val == 11
    full_aces = 1;
end
% init_temp_val is exactly as you think, a temporary value we throw away
user.card_val = user.card_val + init_temp_val;

% The last card that the dealer draws
card_4 = uiimage(fig1, 'Position', [pix_ss(3)*.45+x pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.14]);
[card_4.ImageSource, init_temp_val] = cards;
% We have to increment dealer_x so that the cards render correctly when its
% the dealers turn.
dealer_x = dealer_x+pix_ss(3)*.025;
% The dealer doesn't get soft aces and has to take them at 11. This makes
% it eaiser for us!
dealer_card_val = dealer_card_val+init_temp_val;
% In the rare chance that both the user and dealer get blackjack you have
% to treat it as a push
if dealer_card_val == 21 && user.card_val == 21
    user.card_val = 0;
    % Since its a push the user gets their bet back
    user.chips = user.chips+user.curr_bet;
    user.curr_bet = 0;
    % This shows what the dealers card really was
    card_2.ImageSource = card_2_render_string;
    % It's passed as 0 since its a tie
    gone_bust(0,fig1,pix_ss,scale_font);
    % Setting 'did_inital_deal_end' prevents the hit and hold buttons from
    % being rendered
    did_inital_deal_end = 1;
elseif user.card_val == 21 % We've determined that they're both not 21
    % So what if the user got blackjack?
    user.card_val = 0;
    % The user got blackjack! So they get 3/2 times their bet
    user.chips = user.chips + user.curr_bet +(user.curr_bet* 1.5);
    card_2.ImageSource = card_2_render_string;
    gone_bust(user.curr_bet*1.5,fig1,pix_ss,scale_font);
    did_inital_deal_end = 1;
elseif 21 < user.card_val || dealer_card_val == 21
    % These are both the same outcome - the user losing their bet
    % So they're placed here together
    user.card_val = 0;
    card_2.ImageSource = card_2_render_string;
    % It's a loss so its passed as a negative value
    gone_bust(user.curr_bet*-1,fig1,pix_ss,scale_font);
    did_inital_deal_end = 1;
elseif 21 < dealer_card_val
    % The dealer has lost!
    user.card_val = 0;
    % They get their original bet back as a payout!
    user.chips = user.chips+ user.curr_bet*2;
    % The dealers first card is dealt face down so we need to change it to
    % the actual card the dealer drew.
    card_2.ImageSource = card_2_render_string;
    % Since they won its passed as a positive value
    gone_bust(user.curr_bet,fig1,pix_ss,scale_font);
    did_inital_deal_end = 1;


end
if ~did_inital_deal_end
    hit_btn = uibutton(fig1, 'push',                                        ...
        'BackgroundColor', [0.05 0.25 0.0],           ...
        'Position', [pix_ss(4)*.1 pix_ss(3)*.14 pix_ss(4)*.1 pix_ss(4)*.1],                  ...
        'FontSize', 18*scale_font, 'FontWeight', 'bold',         ...
        'FontColor', [1 1 1],                         ...
        'VerticalAlignment', 'Center',                ...
        'Text', 'Hit Me!',                            ...
        'Visible', 'on',                            ...
        'ButtonPushedFcn', {@hit,card_2,card_2_render_string,fig1,pix_ss,scale_font});
    hold_btn = uibutton(fig1, 'push',                                       ...
        'BackgroundColor', [0.05 0.25 0.0],           ...
        'Position', [pix_ss(4)*.2 pix_ss(3)*.14 pix_ss(4)*.1 pix_ss(4)*.1],                  ...
        'FontSize', 18*scale_font, 'FontWeight', 'bold',         ...
        'FontColor', [1 1 1], 'VerticalAlignment','Center', ...
        'Visible', 'on', 'Text', 'Stand',                            ...
        'ButtonPushedFcn', ...
        {@hold, hit_btn,card_2,card_2_render_string,fig1,pix_ss,scale_font});
end
uiwait(fig1);


    function hit(hit_btn,~,card_2,card_2_render_string,fig1,pix_ss,scale_font)
        % hit is a callback function that is called when the user clicks the 'hit_btn'
        % hit generates a random card for the user and busts if the users total card value is over 21
        % Input arguments:
        %       hit_btn -> The button that is passed to the callback function
        %       Discarded
        %       card_2 -> The dealers face-down card that will be flipped if the hand ends
        %       card_2_render_string -> The file path to render the dealers card
        % Output arguments:
        %       None
        [render_string, temp_val] = cards;
        % This check is to keep in-line with the soft aces rule
        if user.card_val > 10 && temp_val == 11
            temp_val = 1;
        end
        user.card_val = user.card_val + temp_val;
        % The new card is generated and is put on the screen
        uiimage(fig1, 'Position', [pix_ss(3)*.475+x pix_ss(4)*.03 pix_ss(3)*.1 pix_ss(4)*.14],'ImageSource',render_string);

        % There is a card at the current x position so we have to increment
        x = x+ pix_ss(3)*.025;

        % We're playing soft aces so the user won't actually lose in this
        % situation, and the ace gets turned into a 1
        if user.card_val > 21 && full_aces
            user.card_val = user.card_val - 10;
            full_aces = 0;
        elseif user.card_val > 21
            % Changes the dealers
            card_2.ImageSource = card_2_render_string;
            uilabel(fig1, 'FontSize', 20*scale_font, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'BUST! YOU LOST ');
            uieditfield(fig1, 'numeric', 'Limits', [0 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20*scale_font, 'FontColor', [0.8 0.15 0.15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', user.curr_bet);
            uilabel(fig1, 'FontSize', 20*scale_font, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',  'FontWeight', 'Bold',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips!');
            % This resets the users betting values and returns that
            % modified struct
            user.card_val = 0;
            user.curr_bet = 0;
            user_return = user;
            hit_btn.Visible = 'off';
            hold_btn.Visible = 'off';
            % Displays the end buttons to allow the user to choose where
            % they want to go next
            display_buttons(fig1,pix_ss,scale_font);



        end
    end
    function hold(hold_btn,~,hit_btn,card_2,card_2_render_string,fig1,pix_ss,scale_font)
        % hold is a callback function that is called when the user clicks the 'hold' button
        % It represents the end of the users turn (Unless the user goes bust!) and starts the dealers turn
        % It hides the users buttons, starts the dealers turn, and then determines who won
        % Input arguments:
        %       hold_btn -> This gets passed by the callback and is used to hide the button
        %       Discarded -> Discarded event data
        %       hit_btn -> Allows us to hide the hit button
        %       card_2 -> This is the dealers card that will be unhid at the end of the turn
        %       card_2_render_string -> The file path of the card
        %       fig1 -> A handle to the current figure
        %       pix_ss -> The screen resolution of the user
        %       scale_font -> The percentage that the font needs to scale
        % Output arguments:
        %       None

        % The hand is over so these need to be hidden!
        hold_btn.Visible = 'off';
        hit_btn.Visible = 'off';
        start_pos = pix_ss(3)*.45;
        % The hand is over so the dealer needs to turnover his hidden card
        card_2.ImageSource = card_2_render_string;
        % As the rules state till the dealer has less than 17 cards he must
        % draw
        while dealer_card_val < 17
            [render_string,dealer_draw] = cards;
            uiimage(fig1, 'Position', [start_pos+dealer_x pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.14], 'ImageSource',render_string);
            dealer_x = dealer_x+pix_ss(3)*.025;
            dealer_card_val = dealer_card_val + dealer_draw;
        end
        % The dealer has gone bust!
        if 21 < dealer_card_val

            user.chips = user.chips+ user.curr_bet*2;
            gone_bust(user.curr_bet,fig1,pix_ss,scale_font);
            % The user has lost!
        elseif user.card_val < dealer_card_val

            gone_bust(user.curr_bet*-1,fig1,pix_ss,scale_font);
            % It's a push!
        elseif user.card_val == dealer_card_val

            user.chips = user.chips+user.curr_bet;
            gone_bust(0,fig1,pix_ss,scale_font);
            % dealer lost!
        elseif dealer_card_val < user.card_val

            user.chips = user.chips + user.curr_bet*2;
            gone_bust(user.curr_bet,fig1,pix_ss,scale_font);
        end



    end


    function gone_bust(chips_result,fig1,pix_ss,scale_font)
        % gone_bust is a function that is called when the hand is over, it displays the next options for the user
        % It displays a screen telling the user the amount of chips they won or lost
        % gone_bust then displays buttons that the user clicks to be taken to different scenes
        % These buttons are only displayed if appropriate, and when the user fully loses all of their money and chips only an exit button will be displayed
        % Input arguments:
        %       chips_result -> A value representing the amount of chips won or lost during the hand. If it is negative there was a loss!
        %       fig1 -> A handle to our current figure
        %       pix_ss -> The users current screen resolution
        %       scale_font -> The percentage that we need to scale the font
        % Output arguments:
        %       None

        % chips_result gets passed as negative if the user lost chips
        if 0 < chips_result %
            uilabel(fig1, 'FontSize', 20, 'FontColor', [0.2 0.6 0.15], 'FontWeight', 'Bold',              ...
                'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                'White', 'Text', 'YOU WON! ');
            uieditfield(fig1, 'numeric', 'Limits', [-1 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20, 'FontColor', [0.2 0.6 0.15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', chips_result);
            uilabel(fig1, 'FontSize', 20, 'FontColor', [0.2 0.6 0.15], 'FontWeight', 'Bold',              ...
                'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips ');

        elseif 0 == chips_result % This happens during a push
            uilabel(fig1, 'FontSize', 20, 'FontColor', [1 0.41 0.16], 'FontWeight', 'Bold',              ...
                'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'YOU TIED ');
            uieditfield(fig1, 'numeric', 'Limits', [-1 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20, 'FontColor', [1 0.4 0.15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', chips_result);
            uilabel(fig1, 'FontSize', 20, 'FontColor', [1 0.41 0.16], 'FontWeight', 'Bold',              ...
                'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips ');

        else % The value was negative and the user lost their bet!
            uilabel(fig1, 'FontSize', 20, 'FontColor', [.8 .15 .15], 'FontWeight', 'Bold',              ...
                'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'YOU LOST ');
            uieditfield(fig1, 'numeric', 'Limits', [-1 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20, 'FontColor', [.8 .15 .15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', chips_result*-1);
            uilabel(fig1, 'FontSize', 20, 'FontColor', [.8 .15 .15], 'FontWeight', 'Bold',              ...
                'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips ');
        end
        user.curr_bet = 0; % Resets the users bet since it's over
        user.card_val = 0;
        user_return = user; % Returns the modified user struct
        % This calls display buttons to allow the user to choose where they
        % go next
        display_buttons(fig1,pix_ss,scale_font);
    end
    function display_buttons(fig1,pix_ss,scale_font)
        % display_buttons displays the end buttons that the user chooses
        % where to go in the game next. Such as the cashier, or to play
        % again
        %   Input arguments:
        %       fig1 -> The handle to our current figure
        %       pix_ss -> The screen size of the user
        %       scale_font -> The scaling factor of our font size
        %   Output arguments:
        %       None
        if 5 <= user.money % The user needs atleast 5 dollars to buy .1 of a chip
            uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                'FontSize', 26*scale_font, 'FontWeight', 'bold',         ...
                'Position', [pix_ss(3)*.8 pix_ss(4)*.6 pix_ss(3)*.2 pix_ss(4)*.1], 'Text', 'Want to buy more chips?', ...
                'ButtonPushedFcn', {@call_cashier,fig1});
        end
        if 0.1 <= user.chips % The minimum bet!
            uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                'FontSize', 26*scale_font, 'FontWeight', 'bold','Backgroundcolor','r',         ...
                'Position', [pix_ss(3)*.8 pix_ss(4)*.5 pix_ss(3)*.2 pix_ss(4)*.1], 'Text', 'Want to play again?', ...
                'ButtonPushedFcn', {@call_table,fig1});
        end
        % This is the end button and it is presented regardless
        % If you have no money and no chips it becomes your only option
        % Fufilling the requirement of exiting upon the user going broke
        uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
            'FontSize', 26*scale_font, 'FontWeight', 'bold',         ...
            'Position', [pix_ss(3)*.8 pix_ss(4)*.4 pix_ss(3)*.2 pix_ss(4)*.1], 'Text', 'Exit', ...
            'ButtonPushedFcn', {@quit_game,fig1});

    end
    function call_cashier(~,~,fig1)
        % call_cashier is a callback function that allows the user to choose where they go next
        % Input arguments:
        %       fig1 -> A handle to our current figure.
        % Output arguments:
        %       None
        goto_what = 1;
        user_return = user;
        uiresume(fig1); % This is what really ends the game because it causes the uiwait
        %(at the bottom of the 'deal_cards' function) to resume
    end
    function call_table(~,~,fig1)
        % call_table is a callback function that allows the user to choose where they go next
        % Input arguments:
        %       fig1 -> A handle to our current figure
        % Output arguments:
        %       None

        goto_what = 2;
        user_return = user;
        uiresume(fig1);
    end
    function quit_game(~,~,fig1)
        % call_table is a callback function that allows the user to choose where they go next
        % Input arguments:
        %       fig1 -> A handle to our current figure
        % Output arguments:
        %       None
        goto_what = 0;
        user_return = user;
        uiresume(fig1);
    end

user_return = user;
end


function [string, val] = cards
% cards is a function that generates a random card and returns its value and filepath
% Input arguments:
%       None
% Output arguments:
%       string -> The string of the filepath
%       val -> The value of the cards

% r generates a random integer between one and 4
% This represents the 'suit' of our card and generates the first part of
% the filepath
r = randi([1 4]);
% c generattes a random integer between one and 13
% This is the actual value of the card and it also represents the final
% part of our file path
c = randi([1 13]);


switch r
    case 1
        suit = 'blackjack\cards_gif\s';
    case 2
        suit = 'blackjack\cards_gif\c';
    case 3
        suit = 'blackjack\cards_gif\h';
    case 4
        suit = 'blackjack\cards_gif\d';
end

switch c % 'val' is set here
    case 1
        num = '1.gif';
        val = 11;
    case 2
        num = '2.gif';
        val = 2;
    case 3
        num = '3.gif';
        val = 3;
    case 4
        num = '4.gif';
        val = 4;
    case 5
        num = '5.gif';
        val = 5;
    case 6
        num = '6.gif';
        val = 6;
    case 7
        num = '7.gif';
        val = 7;
    case 8
        num = '8.gif';
        val = 8;
    case 9
        num = '9.gif';
        val = 9;
    case 10
        num = '10.gif';
        val = 10;
    case 11
        num = 'j.gif';
        val = 10;
    case 12
        num = 'q.gif';
        val = 10;
    case 13
        num = 'k.gif';
        val = 10;
end
string = strcat(suit,num); % Provides the full filepath to open the card and render it
end
