function [user_return,fig1_return,goto_what] = deal_cards(deal_btn,current_bet_label,bet_spinner,cashout_btn,fig1,user,chip_val)
% deal_cards hides betting and restart options in Doge_Blackjack game 
% environment upon users selecting "Deal" to indicate betting has
% concluded. The hand is initiated and cards are dealt to both the player 
% and the dealer.
%   Input arguments
%       deal_btn
%       balance
%       current_bet_label
%       current_bet
%       clr_bet_btn
%       restart_btn
%       cashout_btn
%       fig1
%   Output arguements
%       user_return
   
deal_btn.Visible = 'off';
cashout_btn.Visible = 'off';
current_bet_label.Visible = 'off';
bet_spinner.Visible = 'off';

uilabel(fig1, 'HorizontalAlignment', 'right',          ...
                              'VerticalAlignment', 'center', 'Fontsize',...
                              18, 'FontColor', [1 0.4 0.15], 'Position',...
                              [165 525 90 23], 'Text', 'Pot Size  $');                 

uieditfield(fig1, 'numeric', 'Limits', [0 Inf],              ...
                            'Editable', 'off', 'ValueDisplayFormat',    ...
                            '%9.0f', 'HorizontalAlignment', 'center',   ...
                            'FontSize', 18, 'FontColor', [1 0.4 0.15],  ...
                           'BackgroundColor', [0.1 0.1 0.1], 'Position',...
                        [265 525 108 24], 'Value', user.curr_bet * chip_val);


x = 30;
dealer_card_val = 0;
hold_btn = struct();
did_inital_deal_end = 0;
function [] = initial_deal() %This is where the GAME IS PLAYED. ALL user action e.g standing, hitting etc. Starts and ends HERE
% Initial Deal
card_1 = uiimage(fig1, 'Position', [575 30 105 140]);
                [card_1.ImageSource, user.card_val] = cards();
                   

   
    card_2 = uiimage(fig1, 'Position', [600 285 85 115]);
                card_2.ImageSource = 'b1fv.gif';

[~,dealer_card_val] = cards();

   
    card_3 = uiimage(fig1, 'Position', [605 30 105 140]);
                [card_3.ImageSource, temp_val] = cards();
                  
user.card_val = user.card_val + temp_val;
    
    card_4 = uiimage(fig1, 'Position', [625 285 85 115]);
                [card_4.ImageSource, temp_val] = cards();
                
dealer_card_val = dealer_card_val+temp_val;

 if push(user.card_val, dealer_card_val)    
    user.card_val = 0;
    user.chips = user.chips+user.curr_bet;
    user.curr_bet = 0;
    user_return = user;
    gone_bust(0);
    did_inital_deal_end = 1;
 elseif user.card_val == 21
    user.card_val = 0;
    user.chips = user.chips + user.curr_bet +(user.curr_bet* 1.5);
    user_return = user;
    gone_bust(user.curr_bet*1.5);
    did_inital_deal_end = 1;
 elseif 21 < user.card_val || dealer_card_val == 21
     user.card_val = 0;
     user_return = user;
     gone_bust(user.curr_bet*-1);
     did_inital_deal_end = 1;
 elseif 21 < dealer_card_val
     user.card_val = 0;
     user.chips = user.chips+ user.curr_bet*2;
     user_return = user;
     gone_bust(user.curr_bet);
     did_inital_deal_end = 1;


 end     
if ~did_inital_deal_end
hit_btn = uibutton(fig1, 'push',                                        ...
                          'BackgroundColor', [0.05 0.25 0.0],           ...
                          'Position', [115 265 85 85],                  ...
                          'FontSize', 18, 'FontWeight', 'bold',         ...
                          'FontColor', [1 1 1],                         ...
                          'VerticalAlignment', 'Center',                ...
                          'Text', 'Hit Me!',                            ...
                            'Visible', 'on',                            ...
                        'ButtonPushedFcn', @hit);
hold_btn = uibutton(fig1, 'push',                                       ...
                          'BackgroundColor', [0.05 0.25 0.0],           ...
                          'Position', [335 265 85 85],                  ...
                          'FontSize', 18, 'FontWeight', 'bold',         ...
                          'FontColor', [1 1 1], 'VerticalAlignment','Center', ...
                           'Visible', 'on', 'Text', 'Stand',                            ...
                            'ButtonPushedFcn', ...
                          {@hold, hit_btn});  
end
                   
uiwait(fig1);
end
    function is_true = push(user_card_val, dealer_card_val)
       if user_card_val == dealer_card_val
           is_true = 1;
       else
           is_true = 0;
       end
    end
    function [] = hit(hit_btn,~)
       [render_string, temp_val] = cards();
       if user.card_val == 20 && temp_val == 11
           temp_val = 1;
       end
       user.card_val = user.card_val + temp_val;

        new_card = uiimage(fig1, 'Position', [605+x 30 105 140]);
        new_card.ImageSource = render_string;
        
        x = x + 30;

            if user.card_val > 21
                uilabel(fig1, 'FontSize', 40, 'FontColor',               ...
                   [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                   'Position', [215 365 107 53], 'BackgroundColor',     ...
                   [0.1 0.1 0.1], 'Text', 'Bust!');
               
               user.card_val = 0;
               user_return = user;
               hit_btn.Visible = 'off';
               hold_btn.Visible = 'off';
               gone_bust(user.curr_bet*-1);
             
              
            end    
    end

    function [] = gone_bust(chips_result)
         if 1 < chips_result
             uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                   [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                   'Position', [215 265 107 100], 'BackgroundColor',     ...
                   [0.1 0.1 0.1], 'Text', 'Congrats you won');
         else
             %Put something here saying they lost x amoun
              uilabel(fig1, 'FontSize', 20, 'FontColor',               ...
                   [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                   'Position', [215 265 107 100], 'BackgroundColor',     ...
                   [0.1 0.1 0.1], 'Text', 'Oops! You lost');
         end
         user.curr_bet = 0;
         if 0 < user.money      
           uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [760 340 400 200], 'Text', 'Want to buy more chips?', ...
                          'ButtonPushedFcn', {@call_cashier});
         end
            if 0 < user.chips
            uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 26, 'FontWeight', 'bold','Backgroundcolor','r',         ...
                       'Position', [760 540 400 200], 'Text', 'Want to play again?', ...
                          'ButtonPushedFcn', {@call_table});
            end      
                         

            uibutton(fig1, 'push', 'BackgroundColor', [0.9 0.9 0.9],     ... 
                          'FontSize', 16, 'FontWeight', 'bold',         ...
                       'Position', [760 140 400 200], 'Text', 'Exit', ...
                          'ButtonPushedFcn', @quit_game);          
        end
   
       function call_cashier(~,~)
                
                goto_what = 1;
                uiresume(fig1);
        
               
       end
        function call_table(~,~)
                  
                  goto_what = 2;
                  uiresume(fig1);
              end
  function quit_game(~,~)
   exit;
  end


    function [] = hold(hold_btn,~,hit_btn)
        
      
        hold_btn.Visible = 'off';
        hit_btn.Visible = 'off';
        start_pos = 625+x;
        while dealer_card_val < 17
           [~,dealer_draw] = cards();
            uiimage(fig1, 'Position', [start_pos 285 85 115], 'ImageSource','b1fv.gif');
            start_pos = start_pos+x;
            dealer_card_val = dealer_card_val + dealer_draw;
        end
        if 21 < dealer_card_val
            user.card_val = 0;
            user.chips = user.chips+ user.curr_bet*2;
            gone_bust(user.curr_bet);
        elseif user.card_val < dealer_card_val
            user.card_val = 0;
            gone_bust(user.curr_bet*-1);
        elseif push(user.card_val, dealer_card_val)
            user.card_val = 0;
            user.chips = user.chips+user.curr_bet;
            gone_bust(0);
        elseif dealer_card_val < user.card_val
            user.card_val = 0;
            user.chips = user.chips + user.curr_bet*2;
            gone_bust(user.curr_bet);
        end
        
        

    end
    
function [string, val] = cards
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

initial_deal;
user_return = user;
fig1_return = fig1;
end