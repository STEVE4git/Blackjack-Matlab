%   MAIN WINDOW
% Generate main window:
fig = uifigure('Name', 'Doge Blackjack');   %Generates main window
        fig.Position=[128 56 1280 720];     %set window position and size
        set(fig,'color','black');
        set(fig,'Pointer','hand');

%---------------------------------------------------------------
%   MAIN MENU
% Enable this section ONLY to generate the main start menu background and push buttons on startup.
% Clicking "New Game" should disable this section of code 
% and enable Cashier's Desk window prompting user to buy chips.

    %Generate Main Menu background:
FigMain = uiimage(fig);
      FigMain.Position = [250 45 750 701];
      FigMain.ImageSource = 'backgrounds\Dogearspalace_animated(1).gif';

    %"New Game" push-button
NewGameButton = uibutton(fig, 'push');
      NewGameButton.Icon = 'buttons\newgame.png';
      NewGameButton.IconAlignment = 'center';
      NewGameButton.BackgroundColor = [0 0 0];
      NewGameButton.Position = [285 200 165 45];
      NewGameButton.Text = '';

    %"Quit" push-button
QuitButton = uibutton(fig, 'push');
      QuitButton.Icon='buttons\quitgame.png';
      QuitButton.IconAlignment = 'center';
      QuitButton.BackgroundColor = [0 0 0];
      QuitButton.Position = [285 145 165 45];
      QuitButton.Text = '';
      
% ---------------------------------------------------------------
%   CASHIER'S DESK
% Enable this section to generate Cashier Window for purchasing chips.
% Generates when initiating New Game or upon clicking "Buy Chips" during game.

    % Generates Buy Chips window
    % set window position and size
BuyChipsfig = uifigure('Name', 'Cashier');         
       BuyChipsfig.Position=[375 75 640 560];      
       set(BuyChipsfig,'color','black');

    % Generate window background
Cashierfig = uiimage(BuyChipsfig);                 
       Cashierfig.Position = [0 0 640 560];
       Cashierfig.ImageSource = 'backgrounds\Cashier.jpg';

    % Generate spinner label
BuyChipsSpinnerLabel = uilabel(BuyChipsfig);
       BuyChipsSpinnerLabel.BackgroundColor = [.9 .9 .9];
       BuyChipsSpinnerLabel.FontSize = 14;
       BuyChipsSpinnerLabel.FontWeight = 'bold';
       BuyChipsSpinnerLabel.HorizontalAlignment = 'center';
       BuyChipsSpinnerLabel.Position = [215 165 235 22];
       BuyChipsSpinnerLabel.Text = 'How many chips would you like?';

    % Generate editable spinner field
BuyChipsSpinner = uispinner(BuyChipsfig);
       BuyChipsSpinner.Position = [305 135 65 22];
       BuyChipsSpinner.Limits = [0 Inf];

    % Generate "Let's Play" button
DoneBuyChipsButton = uibutton(BuyChipsfig, 'push');
       DoneBuyChipsButton.BackgroundColor = [0.85 0.85 0.85];
       DoneBuyChipsButton.FontSize = 14;
       DoneBuyChipsButton.FontWeight = 'bold';
       DoneBuyChipsButton.FontColor = [0 0 0];
       DoneBuyChipsButton.Position = [265 45 125 26];
       DoneBuyChipsButton.Text = 'Let''s Play!';

% ---------------------------------------------------------------
%   BLACKJACK GAME
% Enable this section to generate the blackjack game environment.
% Clicking the chip icons should increase the "current bet" field by their respective amounts
% and when player clicks "Deal!," betting buttons should disable and cards should be generated.

    % Generates Blackjack table and dealer graphics.
figStart = uiimage(fig);
       figStart.BackgroundColor = [0 0 0];
       figStart.Position = [0 0 1280 720];
       figStart.ImageSource = 'backgrounds\Main.jpeg';

    % Balance appears in top left corner
        % Balance label
BalanceLabel = uilabel(fig);
       BalanceLabel.HorizontalAlignment = 'center';
       BalanceLabel.FontSize = 16;
       BalanceLabel.FontColor = [.15 .7 0];
       BalanceLabel.Position = [185 650 63 22];
       BalanceLabel.Text = 'Balance';

        % Balance value
Balance = uieditfield(fig, 'numeric');
       Balance.Limits = [0 Inf];
       Balance.ValueDisplayFormat = '%9.0f';
       Balance.FontSize = 16;
       Balance.Editable = 'off';
       Balance.HorizontalAlignment = 'center';
       Balance.FontColor = [.15 .7 0];
       Balance.BackgroundColor = [0.1 0.1 0.1];
       Balance.Position = [250 650 86 22];
       Balance.Value = 5000;    %Balance value should be linked to running total

    % Chip label
ChipLabel = uilabel(fig);
       ChipLabel.HorizontalAlignment = 'center';
       ChipLabel.FontSize = 16;
       ChipLabel.FontColor = [.8 .8 .8];
       ChipLabel.Position = [185 615 63 22];
       ChipLabel.Text = 'Chips';

    % Chip quantity owned
ChipQuantity = uieditfield(fig, 'numeric');
       ChipQuantity.Limits = [0 Inf];
       ChipQuantity.ValueDisplayFormat = '%5.0f';
       ChipQuantity.FontSize = 16;
       ChipQuantity.Editable = 'off';
       ChipQuantity.HorizontalAlignment = 'center';
       ChipQuantity.FontColor = [.8 .8 .8];
       ChipQuantity.BackgroundColor = [0.1 0.1 0.1];
       ChipQuantity.Position = [250 615 86 22];
       ChipQuantity.Value = 0;  %Number of chips should correspond with purchased chip and bets

    % Button allowing user to buy more chips during gameplay if desired
BuyChipsButton = uibutton(fig, 'push');
       BuyChipsButton.BackgroundColor = [0.15 0.15 0.15];
       BuyChipsButton.FontSize = 14;
       BuyChipsButton.FontWeight = 'bold';
       BuyChipsButton.FontColor = [.8 .8 .8];
       BuyChipsButton.Position = [350 613 125 26];
       BuyChipsButton.Text = 'BUY CHIPS';

% ---------------------------------------------------------------
%Cashout button - Displays total winnings and exits game after 10 seconds
% if window not closed.
% --End game window not available at this time.--

CashoutChipsButton = uibutton(fig, 'push');
       CashoutChipsButton.BackgroundColor = [0.15 0.15 0.15];
       CashoutChipsButton.FontSize = 14;
       CashoutChipsButton.FontWeight = 'bold';
       CashoutChipsButton.FontColor = [.15 .7 0];
       CashoutChipsButton.Position = [350 649 150 26];
       CashoutChipsButton.Text = 'CASHOUT AND EXIT';

% ---------------------------------------------------------------
%   BETTING PUSH BUTTONS
% Generate betting push-buttons in Blackjack game environment
% These should only remain enabled when new round is initiated

    % Five buttons are generated for bet values $25, $50, $100, $500, $1000
    % These values correspond with 1, 2, 4, 20, and 40 chips, respectively.

    %Bet 1 Chip
Button25 = uibutton(fig, 'push');   
       Button25.Icon = 'buttons\single25.png';
       Button25.BackgroundColor = [0.05 0.25 0.0];
       Button25.Position = [100 450 64 56];
       Button25.Text = '';

    %Bet 2 chips
Button50 = uibutton(fig, 'push');
       Button50.Icon = 'buttons\single50.png';
       Button50.BackgroundColor = [0.05 0.25 0.0];
       Button50.Position = [185 450 64 56];
       Button50.Text = '';

    %Bet 4 chips
Button100 = uibutton(fig, 'push');  
       Button100.Icon = 'buttons\single100.png';
       Button100.BackgroundColor = [0.05 0.25 0.0];
       Button100.Position = [270 450 64 56];
       Button100.Text = '';

    %Bet 20 chips
Button500 = uibutton(fig, 'push');  
       Button500.Icon = 'buttons\single500.png';
       Button500.BackgroundColor = [0.05 0.25 0.0];
       Button500.Position = [355 450 64 56];
       Button500.Text = '';

    %Bet 40 chips
Button1000 = uibutton(fig, 'push'); 
       Button1000.Icon = 'buttons\single1000.png';
       Button1000.BackgroundColor = [0.05 0.25 0.0];
       Button1000.Position = [440 450 64 56];
       Button1000.Text = '';

    % Current bet value is generated
        % Current Bet label displayed
CurrentBetLabel = uilabel(fig);                 
       CurrentBetLabel.HorizontalAlignment = 'center';
       CurrentBetLabel.FontSize = 18;
       CurrentBetLabel.FontColor = [1 0.4 0.15];
       CurrentBetLabel.Position = [150 525 98 23];
       CurrentBetLabel.Text = 'Current Bet';

        % Current Bet value displayed
CurrentBet = uieditfield(fig, 'numeric');
       CurrentBet.Limits = [25 Inf];
       CurrentBet.ValueDisplayFormat = '%9.0f';
       CurrentBet.Editable = 'off';
       CurrentBet.HorizontalAlignment = 'center';
       CurrentBet.FontSize = 18;
       CurrentBet.FontColor = [1 0.4 0.15];
       CurrentBet.BackgroundColor = [0.1 0.1 0.1];
       CurrentBet.Position = [265 525 108 24];
       CurrentBet.Value = 150;     %This value should adjust based on users desired bet

    % "Clear Bet" button clears current bet field
ClearBetButton = uibutton(fig, 'push');
       ClearBetButton.BackgroundColor = [0.15 0.15 0.15];
       ClearBetButton.FontSize = 14;
       ClearBetButton.FontWeight = 'bold';
       ClearBetButton.FontColor = [1 1 1];
       ClearBetButton.Position = [385 524 96 26];
       ClearBetButton.Text = 'CLEAR BET';

    % "DEAL!" button disables betting and "Buy Chips" buttons. Initial cards are then generated
DealButton = uibutton(fig, 'push');
       DealButton.BackgroundColor = [0.9 0.9 0.9];
       DealButton.FontName = 'Arial';
       DealButton.FontSize = 16;
       DealButton.FontWeight = 'bold';
       DealButton.Position = [250 375 96 30];
       DealButton.Text = 'DEAL!';



%QUITGAME RENDERING-------------------
%Render a menu here that prompts the user if they really want to quit the game

function end_menu = uibutton 



