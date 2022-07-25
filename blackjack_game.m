%Blackjack game. Reads user input, allows betting
%Written by: Stephen Martin
%This is the main file for running the game and contains the important logic regarding how the game works
%Functions are run from the main while loop stopping when the user runs out of money

function [] = main() % The  main entry point of the matlab function
   
    human_money =  5000; %these are our starting values
    chips_cost = 50;
    current_chips = 0;

    current_hand = generate_cards(); %Generates cards one by one 
    graphics_renderer_main(); %Starts rendering the initial scene. This will be the title screen 

    %await user to click on START GAME

    %Call function to scene transition to the blackjack table


    bet_results = validation_bet_check(human_money, current_chips); %This will needed to be graphicized but this checks user input and allows the buying of chips

    while 0 < human_money %The main loop of the function

        graphics_renderer(users_cards,dealers_cards,current_chips); %Changes the scene and starts the game. Requires parsing of wether the cards need to be faceup/facedown. Renders current chips

        user_reaction_to_deal = waitforbuttonpress;
        if user_reaction_to_deal == 1
            user_reaction_to_deal = user_key_bets(user_reaction_to_deal.CurrentCharacter);
        else
            user_reaction_to_deal = mouse_events_parser(user_reaction_to_deal); %These should return a value from 0-3 based on what the user chose
            


        switch user_reaction_to_deal % Mouse callback should return what the used clicked like this

            case 0  %Each case will need logic dealing with how the cards are dealt.

            end

            case 1

            end

            case 2


            end

            case 3 %there could be a million different splits so this will call a function to parse it

            end


        end

        current_hand = generate_cards(); %More stuff will need to be done before this but each hand will be generated from this function or in the case cards are run out in one of the cases

    end

    prompt_restart = "Do you want to play again? Type yes to do so or no to quit";
    restart_string = lower(input(prompt_restart));

    if !strcmp("no", restart_string) %Not sure if Mr.Scott even wants an option to restart.. Going to add this though since I saw it in the design doc
        main(); % Recursion. Get used to it 
    end    

end
function end_value = end_game(user_key)
    should_end = render_end_game() % Pops up a menu that needs to be handled by Mouse Events or keyboard events




end




