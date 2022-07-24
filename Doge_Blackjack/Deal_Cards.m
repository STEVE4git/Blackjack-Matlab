function Deal_Cards(Deal_Btn, Balance, Current_Bet_Label, Current_Bet,  ...
        Btn_25, Btn_50, Btn_100, Btn_500, Btn_1000, Clr_Bet_Btn,        ...
        Restart_Btn, Cashout_Btn, fig3)
% Deal_Cards hides betting and restart options in Doge_Blackjack game 
% environment upon users selecting "Deal" to indicate betting has
% concluded. The hand is initiated and cards are dealt to both the player 
% and the dealer.
%   Input arguements
%       Deal_Btn
%       Balance
%       Current_Bet_Label
%       Current_Bet
%       Btn_25
%       Btn_50
%       Btn_100
%       Btn_500
%       Btn_1000
%       Clr_Bet_Btn
%       Restart_Btn
%       Cashout_Btn
%       fig3
%   Output arguements
%       None
   
Balance.Value = Balance.Value - Current_Bet.Value * 25;
Deal_Btn.Visible = 'off';
Btn_25.Visible = 'off';
Btn_50.Visible = 'off';
Btn_100.Visible = 'off';
Btn_500.Visible = 'off';
Btn_1000.Visible = 'off';
Clr_Bet_Btn.Visible = 'off';
Restart_Btn.Visible = 'off';
Cashout_Btn.Visible = 'off';
Current_Bet.Visible = 'off';
Current_Bet_Label.Visible = 'off';


Pot_Size_Label = uilabel(fig3, 'HorizontalAlignment', 'right',          ...
                              'VerticalAlignment', 'center', 'Fontsize',...
                              18, 'FontColor', [1 0.4 0.15], 'Position',...
                              [165 525 90 23], 'Text', 'Pot Size  $');                 

Pot_Size = uieditfield(fig3, 'numeric', 'Limits', [0 Inf],              ...
                            'Editable', 'off', 'ValueDisplayFormat',    ...
                            '%9.0f', 'HorizontalAlignment', 'center',   ...
                            'FontSize', 18, 'FontColor', [1 0.4 0.15],  ...
                           'BackgroundColor', [0.1 0.1 0.1], 'Position',...
                        [265 525 108 24], 'Value', Current_Bet.Value * 25);


Deck = [1:1:13; 14:1:26; 27:1:39; 40:1:52];
Card_img = 0;

    function [Val] = Cards()
    Card_Draw = Deck(randi(4, 1), randi(13,1));
    [r, c] = find(Card_Draw == Deck);
    Suit = '';
    Num = '';

        switch r
            case 1
                Suit = 'Doge_Blackjack\cards_gif\s';
            case 2
                Suit = 'Doge_Blackjack\cards_gif\c';
            case 3
                Suit = 'Doge_Blackjack\cards_gif\h';
            case 4
                Suit = 'Doge_Blackjack\cards_gif\d';
        end

        switch c
            case 1
                Num = '1.gif';
                Val = 11;
            case 2
                Num = '2.gif';
                Val = 2;
            case 3
                Num = '3.gif';
                Val = 3;
            case 4
                Num = '4.gif';
                Val = 4;
            case 5
                Num = '5.gif';
                Val = 5;
            case 6
                Num = '6.gif';
                Val = 6;
            case 7
                Num = '7.gif';
                Val = 7;
            case 8
                Num = '8.gif';
                Val = 8;
            case 9
                Num = '9.gif';
                Val = 9;
            case 10
                Num = '10.gif';
                Val = 10;
            case 11
                Num = 'j.gif';
                Val = 10;
            case 12
                Num = 'q.gif';
                Val = 10;
            case 13
                Num = 'k.gif';
                Val = 10;
        end
    Card_img = [Suit, Num];
    end

% Initial Deal
Player_Cards = Cards;
x = 30;
y = 25;

    Card_1 = uiimage(fig3, 'Position', [575 30 105 140]);
                Card_1.ImageSource = Card_img;
                    disp(Player_Cards);

Dealer_Cards = Cards;

    pause(0.4)
    Card_2 = uiimage(fig3, 'Position', [600 285 85 115]);
                Card_2.ImageSource = 'b1fv.gif';


Player_Cards = Player_Cards + Cards;

    pause(0.4)
    Card_3 = uiimage(fig3, 'Position', [605 30 105 140]);
                Card_3.ImageSource = Card_img;
                    disp(Player_Cards);

Dealer_Cards = Dealer_Cards + Cards;

    pause(0.4)
    Card_4 = uiimage(fig3, 'Position', [625 285 85 115]);
                Card_4.ImageSource = Card_img;

    pause(0.4)
Hold_Btn = uibutton(fig3, 'push',                                       ...
                          'BackgroundColor', [0.05 0.25 0.0],           ...
                          'Position', [335 265 85 85],                  ...
                          'FontSize', 18, 'FontWeight', 'bold',         ...
                          'FontColor', [1 1 1], 'VerticalAlignment',    ...
                          'Center', 'Text', 'Stand', 'ButtonPushedFcn', ...
                          @(Hold_Btn, event) Hold(Hold_Btn));


Hit_Btn = uibutton(fig3, 'push',                                        ...
                          'BackgroundColor', [0.05 0.25 0.0],           ...
                          'Position', [115 265 85 85],                  ...
                          'FontSize', 18, 'FontWeight', 'bold',         ...
                          'FontColor', [1 1 1],                         ...
                          'VerticalAlignment', 'Center',                ...
                          'Text', 'Hit Me!',                            ...
                          'ButtonPushedFcn', @(Hit_Btn, event)          ...
                          Hit(Hit_Btn));


    function [] = Hit(Hit_Btn)
        Player_Cards = Player_Cards + Cards;

        pause(0.25)
        NewP_Card = uiimage(fig3, 'Position', [605+x 30 105 140]);
            NewP_Card.ImageSource = Card_img;
                     disp(Player_Cards);

        x = x + 30;

            if Player_Cards > 21
                Bust = uilabel(fig3, 'FontSize', 40, 'FontColor',               ...
                   [1 0.41 0.16], 'HorizontalAlignment', 'center',      ...
                   'Position', [215 365 107 53], 'BackgroundColor',     ...
                   [0.1 0.1 0.1], 'Text', 'Bust!');
            Hit_Btn.Visible = 'off';
            Hold_Btn.Visible = 'off';
            end
    end


    function [] = Hold(Hold_Btn)
        Hit_Btn.Visible = 'off';
%         Dealer_Turn;
    end
    
%     function [] = Dealer_Turn(Hold_Btn)
%         while Dealer_Cards < 17
%             Dealer_Cards = Dealer_Cards + Cards;
% 
%             pause(0.25)
%             NewD_Card = uiimage(fig3, 'Position', [625+y 285 85 115]);
%                 NewD_Card.ImageSource = Card_img;
%         
%             y = y + 25;
%         end
%     end

end