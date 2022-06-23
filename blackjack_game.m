%Blackjack game. Reads user input, allows betting
%Written by: Stephen Martin,
%This is the main file for running the game and contains the important logic regarding how the game works
%Functions are run from the main while loop stopping when the user runs out of money

function [] = main() % The  main entry point of the matlab function

    human_money =  5000;
    chips_cost = 50;
    current_chips = 0;
    blackjack_multiplier = 1.5;

    current_hand = generate_cards(); %This is 6 total cards it should be enough for 90% of rounds

    while 0 < human_money %The main loop of the function

        fprintf("You can currently afford %d chips. Do you want to buy more? (Type yes to buy chips)", human_money/chips_cost);
        bet_string = input("", "s");   %All of these command line functions will NEED to be replaced with the graphics stuff. This will recieve a callback from keyboard events

        if strcmp(bet_string, "yes") 
            chips_bought = buy_chips(human_money, chips_cost, false);
            current_chips = current_chips+ chips_bought;
        end

        elseif current_chips < 1
            chips_bought = buy_chips(human_money, chips_cost, true);
            current_chips = current_chips+ chips_bought;
        end    

        
        prompt_bet = "How many chips do you want to bet this round?";
        chips_betted = input(prompt_bet); %This will recieve a callback from keyboard events

        graphics_renderer(current_hand, current_chips); %Changes the scene and starts the game. Requires parsing of wether the cards need to be faceup/facedown

        user_reaction_to_deal = %get MOUSE callback to determine how to react to the deal

        switch(user_reaction_to_deal) % Mouse callback should return what the used clicked like this

        case 'hit'  %Each case will need logic dealing with how the cards are dealt.

        end

        case 'stand'

        end

        case 'doubling down'


        end

        case 'split' %there could be a million different splits so this will call a function to parse it

        end


        end

        current_hand = generate_cards(); %More stuff will need to be done before this but each hand will be generated from this function or in the case cards are run out in one of the cases
        


    end

end


function bought_chips = buy_chips(human_money, chips_cost, out_of_chips)


    prompt = "How many chips do you want to buy?";
    how_many_chips = input(prompt);

    if human_money < chips_cost*how_many_chips
    
        prompt_error = "You don't have enough money to buy the chips!"; %FIXME: Replace with graphics functions
        disp(prompt_error);
        prompt_resolve = "Do you want to try buying chips again? Type yes or no.";
        error_string = input(prompt_resolve, "s");    %BUG_FIX: Replace this with actual graphics code it can't be read from the command prompt.
        lower_string = lower(error_string);

        if strcmp(lower_string, "yes")
            buy_chips(human_money, chips_cost, false); %Recursive function call allowing user to re-input their chips
        end
        elseif out_of_chips
            buy_chips(human_money,chips_cost,true);
        end
     end
    else
        bought_chips = chips_cost*how_many_chips;
    end

end


function cards = generate_cards()

    rng = ('shuffle');
    card_value_size = length(CARD_VALUE);
    card_type_size = length(CARD_TYPE);
    value_matrix = [:,randi([1 card_value_size],6,1)];
    card_type = [:,randi([1 card_type_size],6,1)];

    card_matrix = zeros(6,2);
    card_matrix(:,1) = value_matrix;
    card_matrix(:,2) = card_type;

    cards = card_matrix; %Returns 6 randomly assorted  cards
    
 
end

CARD_VALUE = ['Ace',2,3,4,5,6,7,8,9,10,'J','Q','K']

CARD_SPECIAL = ['ace','j','q','k']

CARD_TYPE = ['Hearts','Spades','Clubs','Diamonds']



