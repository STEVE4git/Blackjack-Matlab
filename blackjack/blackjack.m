function blackjack
% blackjack is the main function that creates our uifigure (fig1) and displays the Doge blackjack main menu
% The main menu contains a 'New Game' and an 'Exit' button utilizing callbacks to get user input
% blackjack contains the main game loop
%   Input arguments:
%       None
%   Output arguments:
%       None

%--------------------------------------------------------------------------
% Initalize RNG
%--------------------------------------------------------------------------
rng('shuffle'); %This makes our pseduorandom numbers as pseudorandom as possible! This sets it as the number of seconds since Jan,1,1970.

%--------------------------------------------------------------------------
% Generate Main Menu background
%--------------------------------------------------------------------------
fig1 = uifigure('Name', 'Blackjack',                               ...
    'Windowstate','fullscreen',                      ...
    'Color', 'black', 'Pointer','hand', 'Visible', 'on');
% 'set' sets the 'root object'(screen) to use the units of pixels. This allows us to position our assets based on the users screen size at runtime
set(0,'units','pixels');
% 'pix_ss' grabs the screen size dimensions and stores it in this variable. It is a row vector of 4 elements.
pix_ss = get(0,'screensize');

%{
--------------------------------------------------------------------------
Why do we need the users screensize?
--------------------------------------------------------------------------
pix_ss contains [<users distance from left and right of screen > <Distance from top and bottom of screen> <Horizontal resolution> <Vertical resolution>]
The first two elements are always set to [1 1] due to matlab wanting a safe margin. The second two elements are what is used
The second two elements (3), (4) of pixel_ss are what we use because they contain the actual resolution!
%}
user = struct('chips',0,'money',5000,'card_val',0,'curr_bet',0);

%{
--------------------------------------------------------------------------
What is this 'user' struct and why use it?
--------------------------------------------------------------------------

This 'struct' which is a grouping of data, in this case it represents the data that we want to store for the user
It contains 4 variables: chips,money,card_val,and curr_bet
chips: We use this member (variable of a struct) to represent the users total current chips
money: We use this member to represent the users running total of money
card_val : We use this member to represent the users current card values during their playtime
curr_bet : We use this member to represent the amount of chips that the user currently bets
The members 'chips' and 'money' and 'curr_bet' can be represented as either a floating point number or an integer
The 'card_val' is always an integer!
We use a struct since it is a neat grouping of data that makes the code more readable, eaiser to manage, 
and prevents the headache of returning 4 different variables!

%}
chip_val = 50; % This sets the chips value for the game. This is dynamic and not hardcoded, and can be set to any positive (non-zero) number.
uiimage(fig1, 'Position', pix_ss,'ImageSource','backgrounds\main_menu_background.gif');
%{
The 'struct' fig_main represents our background for the main Menu
It uses the 'uiimage' function which creates an image of our choice within the figure we just created
We set the position of this (it's size) to the resolution of the current screen so that it takes up the background

%}
%--------------------------------------------------------------------------
% "Quit" push-button
%--------------------------------------------------------------------------
%{
--------------------------------------------------------------------------
    What is the 'Position' property and why are we doing this multiplication?
--------------------------------------------------------------------------

    This creates the 'new game button' within 'fig1' (Our canvas)
    Our position is set based off the aforementioned screen resolution values
    The first value within the 'Position' property(pix_ss(3)) is setting the buttons start location to 1/5 of the current screens length
    The left of the screen represents pixel 0 and as you go right it ends at 1920, the length of the screen
    So, if you have a '1080p' monitor which is 1920(length) x 1080(width) the button starts at pixel 384 from the left of the screen
    This same thing happens for the second element in 'Position' (pix_ss(4)) It states the vertical location of the button is 30% of the height
    The third element in 'Position' represents the buttons horizontal length. In the same way the calculations were performed previously
    The length of the button is 15% of the horizontal resolution of the screen.
    The last element of 'Position' represents the buttons height, which is 12% of the vertical resolution of the screen

%}
uibutton(fig1, 'push', 'BackgroundColor', 'Black',           ...
    'Position', [pix_ss(3)*.2 pix_ss(4)*.12 pix_ss(3)*.15 pix_ss(4)*.12],   ...
    'IconAlignment', 'center',                  ...
    'Text','',... % Weirdly, matlab buttons insert a default text 'Button' if this isn't set. So its set to nothing.
    'Icon', 'buttons\quitgame.png', ...
    'ButtonPushedFcn', {@quit_game,fig1});

    function quit_game(~,~,fig1)
        close(fig1);
    end
%{
--------------------------------------------------------------------------
      CALLBACK STRUCTURE EXPLANATION:
--------------------------------------------------------------------------

      Why can't the user struct be passed as a callback!
      This is due to how callbacks work in matlab.
      When matlab initalizes a callback function it makes a copy of the variable at that specific time
      Thus, not only is the value WRONG but the changes made to the variable in the callback aren't actually made!
      This applies to ALL callback functions in this program and is the reason some critical values such as the 'user' struct
      Can't be passed as a parameter. This is a property of callbacks, and programmers get around this by using 'global variables'
      These are truly 'global' and can be seen throughout any function in the program
      They have unlimited scope (Ability to be seen EVERYWHERE) and can cause erratic and undefined behavior
      Our program solves this rather cleverly through having the 'user' struct only be able to be modified by callbacks in the current scene
      We pass 'user' to each game function, and this copy of 'user' is modified and then safely returned to be passed to the next function
      This means that our program has consistent behavior and allows other programmers to KNOW that all the variables inside a game function
      Won't be modified anywhere else in the program.
      This structure is used for all callbacks that have to modify user related data.
      UI buttons don't follow this because they use handles rather than
      being assigned a value so they can safely be passed to callback
      functions.


%}

%--------------------------------------------------------------------------
% "New Game" push-button
% The brackets { ] next to 'ButtonPushedFvn' allow us to pass variables to
% the callback function. The callback always returns two variables (the
% button itself and the event), so many of our callback functions discard
% those things if they're not needed using ~ (Which means discard/ignore
% parameter)
uibutton(fig1, 'push', 'BackgroundColor', 'Black',       ...
    'Position', [pix_ss(3)*.2 pix_ss(4)*.3 pix_ss(3)*.15 pix_ss(4)*.12],              ...
    'IconAlignment', 'center',                 ...
    'Text','',...
    'Icon', 'buttons\newgame.png',                                ...
    'ButtonPushedFcn', {@begin,user,fig1,pix_ss,chip_val});

%{
--------------------------------------------------------------------------
    What is this 'scale_font' variable?
--------------------------------------------------------------------------

    Short Answer: It scales the font by getting the users horizontal resolution
    and dividing it by the standard resolution we optimized for (1080p).
    This gives us a percentage to scale the fonts!

    Long Answer:
    Our program ran into a few problems with using fullscreen. Since it
    uses the users resolution and doesn't bring up a consistent matlab
    window. We had to engineer a way to consistently display the user
    interface across a wild range of resolutions and aspect ratios. If Aunt
    Minnie wants to use a 320 x 200 monitor who are we to say she can't? So
    we developed scaling techniques to 'scale' our UI to fit these needs.
    So I figured that since all of our problems with font happened to be
    due to horizontal resolution constraints. What if I found out where our
    font looked best, set that as the standard, and scaled based off that?
    The answer is that you get font scaling. 


%}
    function begin(~,~,user,fig1,pix_ss,chip_val)
        % begin Callback function that is called when the user clicks the 'new_game_btn'
        % begin runs the main loop of the program, and continues running untill the user exists
        % It calls all of our other functions
        % Input arguments: None
        % Output arguments: None
        clf(fig1); % Clears our current figure to allow the 'cashier' function to display its images
        goto_what = 1; % Goto the cashier first! They need chips!
        scale_font = pix_ss(3)/1920; % 1920x1080 (1080p) is the default
        while goto_what %This loop allows us to end the program when the condition 'goto_what' is not 0

            switch goto_what % This jumps to whichever function it needs to next
                case 1
                    [user,goto_what] = cashier(user,fig1,pix_ss,chip_val,scale_font);
                case 2
                    [user,goto_what] = the_table(user,fig1,pix_ss,scale_font);
                case 3
                    [user,goto_what] = deal_cards(user,fig1,pix_ss,chip_val,scale_font);
            end

        end
        clf(fig1); % Clears our current figure before passing it to the exit screen
        cashout(user,fig1,chip_val,pix_ss,scale_font); % Brings up the exit screen
        uiwait(fig1,5); % Allows them to view it for 5 seconds
        close(fig1); % Closes the figure and exits the program

    end


end