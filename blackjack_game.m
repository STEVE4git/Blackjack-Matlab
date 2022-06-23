%Blackjack game. Reads user input, allows betting, graphics.__amd64
%Written by: Stephen Martin, 

function [] = main() % The  main entry point of the matlab function

human_money =  5000
chips_cost = 0
current_cards = 52

while 0 < human_money 




end
end


function bought_chips = buy_chips(human_money, chips_cost)


prompt = "How many chips do you want to buy?";
how_many_chips = input(prompt);
if human_money < chips_cost*how_many_chips
    prompt_error = "You don't have enough money to buy the chips!";
    disp(prompt_error);
    prompt_resolve = "Do you want to try buying chips again? Type yes or no.";
    error_string = input(prompt_resolve, "s");
    lower_string = lower(error_string);
    if strcmp(lower_string, "yes")
    buy_chips(human_money, chips_cost);
    end
 end   
bought_chips = chips_cost*how_many_chips;

end


function cards = generate_cards(num_of_cards)
rng = ('shuffle');
card_value_size = length(CARD_VALUE);
card_type_size = length(CARD_TYPE);
rand_mat = randi([1 52],4,13)



end



end

CARD_VALUE = ['Ace','2','3','4','5','6','7','8','9','10','J','Q','K']
CARD_TYPE = ['Hearts','Spades','Clubs','Diamonds']



