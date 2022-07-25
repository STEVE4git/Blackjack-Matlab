function user_return = deal_cards(deal_btn, balance, current_bet_label, current_bet,  ...
        btn_25, btn_50, btn_100, btn_500, btn_1000, clr_bet_btn,        ...
        restart_btn, cashout_btn, fig3,user,chip_val)
% deal_cards hides betting and restart options in Doge_Blackjack game 
% environment upon users selecting "Deal" to indicate betting has
% concluded. The hand is initiated and cards are dealt to both the player 
% and the dealer.
%   Input arguements
%       deal_btn
%       balance
%       current_bet_label
%       current_bet
%       btn_25
%       btn_50
%       btn_100
%       btn_500
%       btn_1000
%       clr_bet_btn
%       restart_btn
%       cashout_btn
%       fig3
%   Output arguements
%       user_return
   
balance.Value = balance.Value - current_bet.Value * chip_val;
deal_btn.Visible = 'off';
btn_25.Visible = 'off';
btn_50.Visible = 'off';
btn_100.Visible = 'off';
btn_500.Visible = 'off';
btn_1000.Visible = 'off';
clr_bet_btn.Visible = 'off';
restart_btn.Visible = 'off';
cashout_btn.Visible = 'off';
current_bet.Visible = 'off';
current_bet_label.Visible = 'off';


pot_size_label = uilabel(fig3, 'HorizontalAlignment', 'right',          ...
                              'VerticalAlignment', 'center', 'Fontsize',...
                              18, 'FontColor', [1 0.4 0.15], 'Position',...
                              [165 525 90 23], 'Text', 'Pot Size  $');                 

pot_size = uieditfield(fig3, 'numeric', 'Limits', [0 Inf],              ...
                            'Editable', 'off', 'ValueDisplayFormat',    ...
                            '%9.0f', 'HorizontalAlignment', 'center',   ...
                            'FontSize', 18, 'FontColor', [1 0.4 0.15],  ...
                           'BackgroundColor', [0.1 0.1 0.1], 'Position',...
                        [265 525 108 24], 'Value', current_bet.Value * 25);



function [] = initial_deal() %This is where the GAME IS PLAYED. ALL user action e.g standing, hitting etc. Starts and ends HERE
dealer_card_val = 0;
% Initial Deal
x = 30;
y = 25;
card_1 = uiimage(fig3, 'Position', [575 30 105 140]);
                [Card_1.ImageSource, user.card_val] = cards();
                   

dealer_cards = cards;

    pause(0.4)
    card_2 = uiimage(fig3, 'Position', [600 285 85 115]);
                card_2.ImageSource = 'b1fv.gif';

[,dealer_card_val] = cards();
temp_val = 0;

    pause(0.4)
    card_3 = uiimage(fig3, 'Position', [605 30 105 140]);
                [card_3.ImageSource, temp_val] = cards();
                  
user.card_val = user.card_val + temp_val;

    pause(0.4)
    card_4 = uiimage(fig3, 'Position', [625 285 85 115]);
                [card_4.ImageSource, temp_val] = cards();
dealer_card_val = dealer_card_val+temp_val;                
    pause(0.4)



hold_btn = uibutton(fig3, 'push',                                       ...
                          'BackgroundColor', [0.05 0.25 0.0],           ...
                          'Position', [335 265 85 85],                  ...
                          'FontSize', 18, 'FontWeight', 'bold',         ...
                          'FontColor', [1 1 1], 'VerticalAlignment',    ...
                          'Center', 'Text', 'Stand', 'ButtonPushedFcn', ...
                          @(hold_btn, event) Hold(hold_btn));


hit_btn = uibutton(fig3, 'push',                                        ...
                          'BackgroundColor', [0.05 0.25 0.0],           ...
                          'Position', [115 265 85 85],                  ...
                          'FontSize', 18, 'FontWeight', 'bold',         ...
                          'FontColor', [1 1 1],                         ...
                          'VerticalAlignment', 'Center',                ...
                          'Text', 'Hit Me!',                            ...
                          'ButtonPushedFcn', @(hit_btn, event)          ...
                          hit(hit_btn));
end
    function [] = hit(hit_btn)
       [render_string, temp_val] = cards();
       user.card_val = user.card_val + temp_val;

        new_card = uiimage(fig3, 'Position', [605+x 30 105 140]);
            new_card.ImageSource = render_string;
        

        x = x + 30;

            if player_cards > 21
                Bust = uilabel(fig3, 'FontSize', 40, 'FontColor',               ...
                   [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                   'Position', [215 365 107 53], 'BackgroundColor',     ...
                   [0.1 0.1 0.1], 'Text', 'Bust!');
            hit_btn.Visible = 'off';
            hold_btn.Visible = 'off';

            end




    function [] = Hold(hold_btn)
        hit_btn.Visible = 'off';
%         Dealer_Turn;
    end
    
%     function [] = Dealer_Turn(hold_btn)
%         while dealer_cards < 17
%             dealer_cards = dealer_cards + cards;
% 
%             pause(0.25)
%             NewD_Card = uiimage(fig3, 'Position', [625+y 285 85 115]);
%                 NewD_Card.ImageSource = Card_img;
%         
%             y = y + 25;
%         end
%     end

function [string, val] = cards()
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
        string = suit+num; % Provides the full filepath to open the card and render it 
        
        end
    end


initial_deal();
user_return = user;
end