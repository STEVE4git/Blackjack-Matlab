%Blackjack game. Reads user input, allows betting
%Written by: Stephen Martin,
%This is the main file for running the game and contains the important logic regarding how the game works
%Functions are run from the main while loop stopping when the user runs out of money

function [] = main() % The  main entry point of the matlab function

    human_money =  5000;
    chips_cost = 50;
    current_chips = 0;
    blackjack_multiplier = 1.5;

    deck = generate_deck();

    while 0 < human_money %The main loop of the function

        fprintf("You can currently afford %d chips. Do you want to buy more? (Type yes to buy chips)", human_money/chips_cost);
        bet_string = input("", "s");

        if strcmp(bet_string, "yes")
            chips_bought = buy_chips(human_money, chips_cost);
        end

        if 0 < current_chips


        
        


    end

end

function 

function deck = generate_deck()

    prompt_deck = "How many decks of blackjack do you want to play? (Enter a number between 1-8)";
    deck_size = input(prompt_deck);


    if 0 < deck_size < 8
        card_matrix = generate_cards(deck_size);
    end

    else
        fprintf("You can't generate decks greater than 8 or less than 1! Type a new number!");
        while 0 < deck_size < 8
            deck_size = input();
            end 

    card_matrix = generate_cards(deck_size);
    end

    deck = card_matrix;
end 

function return_deck = anti_card_counting(current_deck) %This will only be called if the deck size is 
    num_of_columns = size(current_deck)
    evil_swap 
    swap_deck = current_deck(:,[1:2]);


function bought_chips = buy_chips(human_money, chips_cost)


    prompt = "How many chips do you want to buy?";
    how_many_chips = input(prompt);
    if human_money < chips_cost*how_many_chips
        prompt_error = "You don't have enough money to buy the chips!";
        disp(prompt_error);
        prompt_resolve = "Do you want to try buying chips again? Type yes or no.";
        error_string = input(prompt_resolve, "s");    %BUG_FIX: Replace this with actual graphics code it can't be read from the command prompt.
        lower_string = lower(error_string);

        if strcmp(lower_string, "yes")
            buy_chips(human_money, chips_cost); %Recursive function call allowiwng user to re-input their chips
        end

     end
    else
        bought_chips = chips_cost*how_many_chips;
    end

end


function cards = generate_cards(num_of_decks)

    rng = ('shuffle');
    card_value_size = length(CARD_VALUE);
    card_type_size = length(CARD_TYPE);

    matrix_index = 1; %Needed due to standard loop overwriting data 

    if 0 < num_of_decks
        card_matrix = zeros(52,num_of_decks);
        for i = 1:num_of_decks
            rand_card_index = randi([1 card_value_size],52);
            card_type_index = randi([1 card_type_size], 52);
            card_column_vector(:,1)=rand_card_index;
            card_column_vector(:,2)=card_type_index; %These will represent the cards based on the CONSTANTS at the bottom
            card_matrix(:,matrix_index:matrix_index+1);
            matrix_index = matrix_index+2;

        end
        cards = card_matrix;    %Stores the card type and value as a column vector. The key is at the bottom of the file for consistenty
    end
 
end

CARD_VALUE = ['Ace',2,3,4,5,6,7,8,9,10,'J','Q','K']
CARD_TYPE = ['Hearts','Spades','Clubs','Diamonds']



