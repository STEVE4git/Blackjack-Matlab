%Blackjack game. Reads user input, allows betting, graphics.__amd64


function entry = main() % The  main entry point of the matlab function

human_money =  5000
chips_cost = 0
current_cards = 52

while 0 < human_money 




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
        new_input = ""


end


function cards = generate_cards(num_of_cards)



end


function 
