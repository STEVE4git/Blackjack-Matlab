function [user_return,goto_what] = deal_cards(user,fig1,pix_ss,chip_val)
% deal_cards hides betting and restart options in Doge_Blackjack game
% environment upon users selecting "Deal" to indicate betting has
% concluded. The hand is initiated and cards are dealt to both the player
% and the dealer.
%   Input arguments:
%       fig1 -> Current canvas that UI is displayed on
%       user -> Users data
%       chip_val -> Cost of a chip
%       pix_ss -> Users screen size
%   Output arguments
%       user_return -> Returns the modified users data
%       fig1_return -> Returns our current canvas
%       goto_what -> Returns what function should the game execute next



uilabel(fig1, 'HorizontalAlignment', 'center',          ...
    'VerticalAlignment', 'center', 'Fontsize',...
    18, 'FontColor', [1 0.4 0.15], 'Position',...
    [pix_ss(3)*.05 pix_ss(4)*.5 pix_ss(3)*.1 pix_ss(4)*.03], 'Text', 'Pot Size  $');

uieditfield(fig1, 'numeric', 'Limits', [0 Inf],              ...
    'Editable', 'off', 'ValueDisplayFormat',    ...
    '%9.2f', 'HorizontalAlignment', 'center',   ...
    'FontSize', 18, 'FontColor', [1 0.4 0.15],  ...
    'BackgroundColor', [0.1 0.1 0.1], 'Position',...
    [pix_ss(3)*.15 pix_ss(4)*.5 pix_ss(3)*.1 pix_ss(4)*.03], 'Value', user.curr_bet * chip_val);



dealer_card_val = 0;
hold_btn = 0;
dealer_x = pix_ss(3)*.025;
did_inital_deal_end = 0;
x = pix_ss(3)*.025;
card_1 = uiimage(fig1, 'Position', [pix_ss(3)*.5 pix_ss(4)*.03 pix_ss(3)*.1 pix_ss(4)*.14]);
[card_1.ImageSource, user.card_val] = cards;
full_aces = 0;

card_2 = uiimage(fig1, 'Position', [pix_ss(3)*.5 pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.14]);
card_2.ImageSource = 'b1fv.gif';

[card_2_render_string,dealer_card_val] = cards;


card_3 = uiimage(fig1, 'Position', [pix_ss(3)*.5+x pix_ss(4)*.03 pix_ss(3)*.1 pix_ss(4)*.14]);
[card_3.ImageSource, init_temp_val] = cards;
if user.card_val == 11 && init_temp_val == 11
    full_aces = 1;
    init_temp_val = 1;
elseif user.card_val == 11 || init_temp_val == 11
    full_aces = 1;
end

user.card_val = user.card_val + init_temp_val;

card_4 = uiimage(fig1, 'Position', [pix_ss(3)*.5+x pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.14]);
[card_4.ImageSource, init_temp_val] = cards;
dealer_x = dealer_x*2;
dealer_card_val = dealer_card_val+init_temp_val;

if dealer_card_val == 21 && user.card_val == 21
    user.card_val = 0;
    user.chips = user.chips+user.curr_bet;
    user.curr_bet = 0;
    card_2.ImageSource = card_2_render_string;
    gone_bust(0,fig1,pix_ss);
    did_inital_deal_end = 1;
elseif user.card_val == 21
    user.card_val = 0;
    user.chips = user.chips + user.curr_bet +(user.curr_bet* 1.5);
    card_2.ImageSource = card_2_render_string;
    gone_bust(user.curr_bet*1.5,fig1,pix_ss);
    did_inital_deal_end = 1;
elseif 21 < user.card_val || dealer_card_val == 21
    user.card_val = 0;
    card_2.ImageSource = card_2_render_string;
    gone_bust(user.curr_bet*-1,fig1,pix_ss);
    did_inital_deal_end = 1;
elseif 21 < dealer_card_val
    user.card_val = 0;
    user.chips = user.chips+ user.curr_bet*2;
    card_2.ImageSource = card_2_render_string;
    gone_bust(user.curr_bet,fig1,pix_ss);
    did_inital_deal_end = 1;


end
if ~did_inital_deal_end
    hit_btn = uibutton(fig1, 'push',                                        ...
        'BackgroundColor', [0.05 0.25 0.0],           ...
        'Position', [pix_ss(4)*.1 pix_ss(3)*.14 pix_ss(4)*.1 pix_ss(4)*.1],                  ...
        'FontSize', 18, 'FontWeight', 'bold',         ...
        'FontColor', [1 1 1],                         ...
        'VerticalAlignment', 'Center',                ...
        'Text', 'Hit Me!',                            ...
        'Visible', 'on',                            ...
        'ButtonPushedFcn', {@hit,card_2,card_2_render_string,fig1,pix_ss});
    hold_btn = uibutton(fig1, 'push',                                       ...
        'BackgroundColor', [0.05 0.25 0.0],           ...
        'Position', [pix_ss(4)*.2 pix_ss(3)*.14 pix_ss(4)*.1 pix_ss(4)*.1],                  ...
        'FontSize', 18, 'FontWeight', 'bold',         ...
        'FontColor', [1 1 1], 'VerticalAlignment','Center', ...
        'Visible', 'on', 'Text', 'Stand',                            ...
        'ButtonPushedFcn', ...
        {@hold, hit_btn,card_2,card_2_render_string,fig1,pix_ss});
end
uiwait(fig1);


    function hit(hit_btn,~,card_2,card_2_render_string,fig1,pix_ss)
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
        if user.card_val > 10 && temp_val == 11
            temp_val = 1;
        end
        user.card_val = user.card_val + temp_val;

        new_card = uiimage(fig1, 'Position', [pix_ss(3)*.525+x pix_ss(4)*.03 pix_ss(3)*.1 pix_ss(4)*.14]);
        new_card.ImageSource = render_string;
        x = x+x;


        if user.card_val > 21 && full_aces
            user.card_val = user.card_val - 10;
            full_aces = 0;
        elseif user.card_val > 21
            card_2.ImageSource = card_2_render_string;
            uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Bust! You lost ');
            uieditfield(fig1, 'numeric', 'Limits', [0 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20, 'FontColor', [1 0.4 0.15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', user.curr_bet);
            uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips!');

            user.card_val = 0;
            user.curr_bet = 0;
            user_return = user;
            hit_btn.Visible = 'off';
            hold_btn.Visible = 'off';
            display_buttons(fig1,pix_ss);



        end
    end
    function hold(hold_btn,~,hit_btn,card_2,card_2_render_string,fig1,pix_ss)
        % hold is a callback function that is called when the user clicks the 'hold' button
        % It represents the end of the users turn (Unless the user goes bust!) and starts the dealers turn
        % It hides the users buttons, starts the dealers turn, and then determines who won
        % Input arguments:
        %       hold_btn -> This gets passed by the callback and is used to hide the button
        %       Discarded -> Discarded event data
        %       hit_btn -> Allows us to hide the hit button
        %       card_2 -> This is the dealers card that will be unhid at the end of the turn
        %       card_2_render_string -> The file path of the card
        % Output arguments:
        %       None

        hold_btn.Visible = 'off';
        hit_btn.Visible = 'off';

        start_pos = pix_ss(3)*.5;
        card_2.ImageSource = card_2_render_string;
        while dealer_card_val < 17
            [render_string,dealer_draw] = cards;
            uiimage(fig1, 'Position', [start_pos+dealer_x pix_ss(4)*.3 pix_ss(3)*.1 pix_ss(4)*.14], 'ImageSource',render_string);
            dealer_x = dealer_x*2;
            dealer_card_val = dealer_card_val + dealer_draw;
        end

        if 21 < dealer_card_val

            user.chips = user.chips+ user.curr_bet*2;
            gone_bust(user.curr_bet,fig1,pix_ss);

        elseif user.card_val < dealer_card_val

            gone_bust(user.curr_bet*-1,fig1,pix_ss);
        elseif push(user.card_val, dealer_card_val)

            user.chips = user.chips+user.curr_bet;
            gone_bust(0,fig1,pix_ss);
        elseif dealer_card_val < user.card_val

            user.chips = user.chips + user.curr_bet*2;
            gone_bust(user.curr_bet,fig1,pix_ss);
        end



    end


    function gone_bust(chips_result,fig1,pix_ss)
        % gone_bust is a function that is called when the hand is over, it displays the next options for the user
        % It displays a screen telling the user the amount of chips they won or lost
        % gone_bust then displays buttons that the user clicks to be taken to different scenes
        % These buttons are only displayed if appropriate, and when the user fully loses all of their money and chips only an exit button will be displayed
        % Input arguments:
        %       chips_result -> A value representing the amount of chips won or lost during the hand. If it is negative there was a loss!
        % Output arguments:
        %       None
        if 0 <= chips_result
            uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'You won ');
            uieditfield(fig1, 'numeric', 'Limits', [-1 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20, 'FontColor', [1 0.4 0.15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', chips_result);
            uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips ');
        else
            uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.1 pix_ss(4)*.14 pix_ss(3)*.14 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'You lost ');
            uieditfield(fig1, 'numeric', 'Limits', [-1 Inf],              ...
                'Editable', 'off', 'ValueDisplayFormat',    ...
                '%9.2f', 'HorizontalAlignment', 'center',   ...
                'FontSize', 20, 'FontColor', [1 0.4 0.15],  ...
                'BackgroundColor', [.1 .1 .1], 'Position',...
                [pix_ss(3)*.245 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'Value', chips_result*-1);
            uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                'Position', [pix_ss(3)*.33 pix_ss(4)*.14 pix_ss(3)*.08 pix_ss(4)*.08], 'BackgroundColor',     ...
                [1 1 1], 'Text', 'Chips ');
        end
        user.curr_bet = 0;
        user.card_val = 0;
        user_return = user;
        display_buttons(fig1,pix_ss);
    end
    function display_buttons(fig1,pix_ss)
        if 0.1 < user.money
            uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                'FontSize', 16, 'FontWeight', 'bold',         ...
                'Position', [pix_ss(3)*.8 pix_ss(4)*.6 pix_ss(3)*.2 pix_ss(4)*.1], 'Text', 'Want to buy more chips?', ...
                'ButtonPushedFcn', {@call_cashier,fig1});
        end
        if 0.1 < user.chips
            uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
                'FontSize', 26, 'FontWeight', 'bold','Backgroundcolor','r',         ...
                'Position', [pix_ss(3)*.8 pix_ss(4)*.5 pix_ss(3)*.2 pix_ss(4)*.1], 'Text', 'Want to play again?', ...
                'ButtonPushedFcn', {@call_table,fig1});
        end

        uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ...
            'FontSize', 16, 'FontWeight', 'bold',         ...
            'Position', [pix_ss(3)*.8 pix_ss(4)*.4 pix_ss(3)*.2 pix_ss(4)*.1], 'Text', 'Exit', ...
            'ButtonPushedFcn', {@quit_game,fig1});

    end
    function call_cashier(~,~,fig1)
        % call_cashier is a callback function that allows the user to choose where they go next
        % Input arguments:
        %       Discarded
        %       Discarded
        % Output arguments:
        %       None
        goto_what = 1;
        user_return = user;
        uiresume(fig1);
    end
    function call_table(~,~,fig1)
        % call_table is a callback function that allows the user to choose where they go next
        % Input arguments:
        %       Discarded
        %       Discarded
        % Output arguments:
        %       None

        goto_what = 2;
        user_return = user;
        uiresume(fig1);
    end
    function quit_game(~,~,fig1)
        % call_table is a callback function that allows the user to choose where they go next
        % Input arguments:
        %       Discarded
        %       Discarded
        % Output arguments:
        %       None
        goto_what = 0;
        user_return = user;
        uiresume(fig1);
    end

user_return = user;
end


function is_true = push(user_card_val, dealer_card_val)
% is_true is used to determine if a push has occured (Meaning the user and dealer have equal cards!)
% Input arguments:
%       user_card_val -> The total value of the users cards
%       dealer_card_val -> The total value of the dealers cards
% Output arguments:
%       is_true -> 1 (True) or 0 (False)
if user_card_val == dealer_card_val
    is_true = 1;
else
    is_true = 0;
end
end



function [string, val] = cards
% cards is a function that generates a random card and returns its value and filepath
% Input arguments:
%       None
% Output arguments:
%       string -> The string of the filepath
%       val -> The value of the cards
r = randi([1 4]);
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

switch c
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
