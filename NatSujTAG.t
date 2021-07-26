%
%Filename       : <NatSujTAG>
%Program        : This is a text adventure game.
%Outline        :
%Programmer     : <Sujoy Nath>
%Class          : ISC2O3-03 (Mr.Sze)
%Due Date       : <May 4, 2018>
%

%Hello, welcome to my program. This program is a text based adventure game I have created. The story of the game is of the main character, named Yojus Thane, who
%is a legendary dragon slayer who has been resurrected to defeat the evil Dragon King.

%---------- {Variable Declarations} -------------------------------------------------------------------------------------------------------------

% Here are my variable delcarations. Every one of my variables that I will use in my program are going to be declared first, as per the proper I/P/O structure.
%It should be noted that my variable names always start with a prefix based on what variable type that variable is.

% PREFIXES:
% s - string types
% b - boolean types
% i - integer types
% ai - arrays that store integers

var sdirection, scombat_decision : string                                    %  As mentioned in the explaination previously, sdirection is the a variable that stores
% which direction the player wants to head in. That is why it is called sdirection because
% it holds string data types. scombat_decision is for a variable I use to determine if the
% player would like to drink a potion before entering combat.


var stown_location, smenu_selection, sfinal_decision, snum : string         %   This are my other string variables. All of these variables stores where a player is
% headed within a stage except for snum and smenu_selection. smenu_selection stores the
% main menu option that was picked and snum is to check for valid integer inputs which are
% inputed as a string.

var ipotion, icoins, iitem, itreatment, ienter, ioption, inum : int := 0    %   All of these are variables that help the user shop by providing them with the
% corresponding option the user has chosen while in Bardier Town. iocins obviously
% stores how much money the user has. inum is the interger variable where the result is
% stored from checking if the integers were valid.

var ai_weapons_armor : array 1 .. 4 of int := init (0, 0, 0, 0)             % This is an array that stores all of the items at the Blacksmith shop.
var ai_weapons_cost : array 1 .. 4 of int := init (500, 1000, 400, 900)     % This array stores the prices for all the items at the Blacksmith shop.
var ai_potions_cost : array 1 .. 3 of int := init (200, 300, 300)      % This array stores the prices of the potions sold at the Alchemist shop
var ai_potions : array 1 .. 3 of int := init (0, 0, 0)                 % This array stores how many of each potion sold at the Alchemist shop does the player have.

var ai_enemy_rewards_coins : array 1 .. 9 of int := init (80, 120, 180, 400, 500, 600, 200, 800, 1000) % This array stores how many coins does the player get after
% defeating a certain enemy.

var ai_gate_keys : array 4 .. 6 of int := init (0, 0, 0)                        % This stores whether the player has the keys required to enter the last stage,
% The Volcanoes of the King

var ai_enemy_defeat_counter : array 4 .. 9 of int := init (0, 0, 0, 0, 0, 0)    % This stores how many times has a player defeated an enemy. This array was mainly used
% for storing if the player has already defeated a boss or not.


%The in the line below are the most important variables in my COMBAT procedure. Here is a list of what each variable stores:
% iattack,iattack2 : how much damage is done
% iweak,istrong,iweak2,istrong2 : the range of each participant's damage, iweak being the weakest and istrong being the most powerful attack
% ihealth,ihealth2 : how much health does each participant have
% imaxhealth,imaxhealth2 : how much total health does each aprticipant have
% iresult : the result of the battle
% iaction : a decision whether the player wants to drink an health potion, fight or retreat.
var ihealth, ihealth2, iattack, iattack2, istrong, istrong2, iweak, iweak2, stage_location, imaxhealth, imaxhealth2, iresult, iaction : int

var bresult, bfinish : boolean                      %Two boolean variables, bresult stores to check if an input is a valid integer and bfinish determines whether the
% player wants to leave the game.

var itext : int := Font.New ("Palitino:45:italic")  % This is a variable that will help determine the format of the words at the title screen.
var itext2 : int := Font.New ("Palitino:24")        % This is the same as the previous one
icoins := 0                                         % icoins is an integer type variable that stores how many gold coins does the player have. Currently, they
%  they should have 0.

imaxhealth := 100                                   % Initial total health.
ihealth := imaxhealth                               % Setting the HP to be full
istrong := 40                                       % Initial attack powers
iweak := 10
bfinish := false                                    % This tells the computer the game has just started and thus it is false that the game has finished.
% --------------------------- {Check Integer Procedure} ---------------------------------------------------------------

% This procedure checks for valid intger inputs.

procedure Check_Int (var inum : int, var snum : string, var bresult : boolean)
    loop
	get snum                                    % getting the input in string format
	bresult := true                             % setting the result as true that yes it is indeed an integer. This is just the inital assesment before checkin
	for icounter : 1 .. length (snum)           % A for loop to check all the characters within the string
	    case snum (icounter) of                 % a case to check each character
		label "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" :    %If character is a number, it passes through.
		label :
		    bresult := false                                        % if the character is not a number, then immediately, the reslut is set to false and thus
									    % this input is not an integer.
	    end case                                                        % ending the case
	end for                                                             % ending the for loop
	if bresult = false then                                 % Checking if the result is false, the program tells the user to try again.
	    put "Invalid Entry"
	    put "Please Try Again"
	else
	    inum := strint (snum)                           % If the user input is an integer, then the original result never changes and thus we are converting
							    % this string statement into an integer and stroing it in inum
	end if
	exit when bresult = true            % exit the procedure and loop after a valid integer has been inputted.
    end loop
end Check_Int                               % Ending the first procedure.
%---------- {Combat Procedure} ------------------------------------------------------------------------------------------------------------

% This is my combat procedure. This is the most important procedure in my game because a lot of my game uses this procedure.
% Underneath is all the parameter declarations for the procedure.

procedure COMBAT (var istrong, istrong2, iweak, iweak2, imaxhealth, imaxhealth2, ienter, ihealth, ihealth2, iattack, iattack2, iresult, stage_location,
	icoins, iaction : int, var ai_potions : array 1 .. 3 of int, var ai_enemy_rewards_coins : array 1 .. 9 of int, var scombat_decision : string,
	var ai_gate_keys : array 4 .. 6 of int, var ai_enemy_defeat_counter : array 4 .. 9 of int)
    loop                                                                    % We start with a loop
	put "Would you like to drink:"
	put "(1) Armor Buff Potion"
	put "(2) Attack Buff Potion"
	put "Enter any other key to enter combat"
	get scombat_decision                                                % Above, I ask the player whether they would like to use a boost potion
	% before the battle and get their input. I have also provided the options
	% to pick from.

	case scombat_decision of                                            % A case to check which option the player has chosen
	    label "1" :

		%   Underneath, the player has chosen option 1 and wants to drink an armor buff potion. Then this procedure checks to see if the player has that potion
		% and outputs an appropriate action. If the player does have the potion, the game character(Yojus) consumes it and gains its effects, if they don't have
		% it, the program will tell them so and re give them the option to drink a potion. If the player doen't have any type of potion, they can just enter any
		% key and enter combat. ai_potions(2) is the armor buff potion. ai_potions (3) is the attack buff and ai_potions(1) is the health potion.

		if ai_potions (2) < 1 then
		    put "You don't have this potion."
		else
		    ai_potions (2) := ai_potions (2) - 1
		    if ihealth = imaxhealth then
			imaxhealth += 20                     %   Drinking the arrack buff potion gives you 20 more in maxhealth. This if statement checks to see 
							     % that if the player's health is at the maximum health, their health qould go up as well, else, only
							     % the health bar would increase, not the actual health.
			ihealth := imaxhealth
		    else
			imaxhealth += 20
		    end if              
		    put " You have ", imaxhealth, " health points."
		end if
	    label "2" :
	    
	    % This has the same function as what was explained in option 1, only except it is for attack buf potions.
	    
		if ai_potions (3) < 1 then
		    put "You don't have this potion."
		else
		    ai_potions (3) := ai_potions (3) - 1
		    istrong += 20
		    iweak += 20
		    put "You have ", istrong, " attack points."
		end if
	    label :
		put "Entering Battle"                   % After the player is content, this allows for the player to enter combat. ienter checks whether
							% the player has picked the option to enter.
		ienter := 1
	end case
	delay (500)                                     % a little delay
	exit when ienter = 1
    end loop
    ihealth2 := imaxhealth2                             % setting the enemy's health
    cls
    loop
	put "Your health ", ihealth, "/", imaxhealth            % Displaying your health
	put "Enemy health ", ihealth2, "/", imaxhealth2         % Displaying your enemy's health
	randint (iattack, iweak, istrong)                       % Your attack damage calculations
	randint (iattack2, iweak2, istrong2)                    % Your enemy's attack damage calculations
	iresult := 0                                            % setting the combat result has 0 because there is no result.
	if ihealth <= 1 then
	    put "Your HP is too low, it is advised that you drink a health potion or retreat for now." % This is if the player has reall low health or just entered 
												       % combat after losing.
	end if
	
	% Below are the options for the player on to sttack, drink a health potion or retreat. Also tells them how many health potions do they have.
	
	put "Would you like to attack, drink a health potion or retreat?"
	put "(1) Attack"
	put "(2) Drink a health potion. You have ", ai_potions (1), " health ai_potions"
	put "(3) Retreat"
	Check_Int (inum, snum, bresult)                         % Checking for proper integer input
	iaction := inum                                         % setting the action taken to the user input
	case iaction of                                         % checking what option the user has chosen with a case
	    label 1 :
		ihealth2 := ihealth2 - iattack                  % subtracting your attack damage from the enemy's health
		put "You have done ", iattack, " damage to your opponent."  %telling the user of how much damage they have done.
		if ihealth2 <= 0 then                           % Checking to see if the player has won.
		    put "You win"                               % If the player won
		    icoins := icoins + ai_enemy_rewards_coins (stage_location)  % Adding to the reward to the amount of gold coins the player already has. 
		    put "You have received ", ai_enemy_rewards_coins (stage_location), " gold coins for winning."  % Telling the player how much they earned
		    iresult := 1                                                    % Telling the program that the battle ended.
		    
		    % Below, the program checks to see if the enemy defeated is a main boss. If so, then the program marks that boss as defeated and
		    % then checks to see if it was one of the Guardians. If it was a Guardian, then the player will receive a gate key, if not, the program
		    % also checks to see if the user has defeated the final boss (stage_location = 9 because stage_location determines ehich enemy to face).
		    
		    if stage_location > 3 then                                      
			ai_enemy_defeat_counter (stage_location) := 1
			if stage_location < 7 then
			    ai_gate_keys (stage_location) := 1
			else
			    if stage_location = 9 then
				put "Woohoo! You have defeated the Dragon King. You have now saved the "
				put "province of Ryengard from his evil rule. Now that you have finished the"
				put "main quest, you could go back to the Graveyard of Legends and type in"
				put "quit to exit the game, or go to the Town of Bardier and buy all the items."
				delay (8000)
			    end if
			end if
		    end if
		else
		    % If the player has not defeated the enemy, the enemy attacks and the program subtracts the enemy attack from the player's health.
		    % Then it checks to see if the player is still in by checking if their health is at or below zero, if so, the player loses and combat ends.
		    ihealth := ihealth - iattack2
		    delay (100)
		    put "Your opponent has attacked. You have taken ", iattack2, " damage."
		    if ihealth <= 0 then
			ihealth := 1
			put "You lose"
			iresult := 1
		    end if
		end if
		delay (1500)
		cls
	    label 2 :
		% This option is to drink health potions mid battle. It first checks to see if the player has a health potion at all and then allows the player 
		% to refill their health. If the health has reached maximum or beyond, ihealth is set to imaxhealth or the player now has full health.
		
		if ai_potions (1) < 1 then
		    put "You don't have any health ai_potions to use"
		else
		    if ihealth = imaxhealth then
			put "You don't need a health potion. You have maximum health."
		    else
			ai_potions (1) := ai_potions (1) - 1
			ihealth += 50
			if ihealth >= imaxhealth then
			    ihealth := imaxhealth
			end if
			put "You have drank a health potion and gained 50 HP."  
		    end if
		end if
		delay (1500)
		cls
	    label 3 :
		put "You are running away, coward."         % Here the player has chosen to run away
		iresult := 1                            % Combat result is 1 thus combat has ended
		delay (1500)
		cls
	    label :
	end case
	exit when iresult = 1           % Telling th program to exit the loop now that combat has ended
    end loop
end COMBAT                              % Ending COMBAT procedure

%---------------------------------------------- {Main Menu} ------------------------------------------------------------------
loop
    View.Set ("graphics")       %Setting the screen mode into graphics to draw the title screen
    for iscreen : 1 .. 9        % putting black spaces to have the user input be at the bottom.
	put skip
    end for
    Font.Draw ("Return of the Dragon", 20, 260, itext, red)     %These are the animations for the title screen in which the run window shows the title and
								% the main menu options.
    Font.Draw ("King", 235, 200, itext, red)
    Font.Draw ("(1) Play", 235, 145, itext2, blue)
    Font.Draw ("(2) Help", 235, 100, itext2, black)
    get smenu_selection                                         % Getting the chosen option
    case smenu_selection of
	label "1" :                                             % Starting the game
	    %---------------------------------- {Game Start - Prologue} ---------------------------------------------------------------------------------------------

	    View.Set ("screen")         % Setting the run window to screen mode, or elsei won't be allowed to use the clear screen function(cls)
	    cls
	    Text.Color (1)              % Setting the tect color to red.
	    
	    %Underneath is the prologue, properly formatted to my run window.
	    
	    put "Long ago, 2000 years to be exact, the Humans and Dragons lived in peace."
	    put "At the time, the apex species were the dragons, the Humans coming in"
	    put "second. The Dragons were large and powerful creatures who ruled the land"
	    put "at the time. The Humans and Dragons lived in peace for quite a long time,"
	    put "until the Great Dragon War. This war took place after the long power struggle"
	    put "between the Humans and the Dragons. The Dragon King, who was the tyrank of"
	    put "the province of Ryengard, tried to eliminate all humans from the province"
	    put "and later on, tried to take over the Empire. This resulted in the Great"
	    put "Dragon War. The Dragon King was powerful and nearly invincible, he could"
	    put "not be harmed without a special form of magic, dragon slayer magic. This"
	    put "type of magic was created by the Humans long ago in case of a war and"
	    put "could only be passed down through heritage. At the beginning of the war,"
	    put "there was death and devastation, until one day, a heroby the name Yojus"
	    put "Thane appeared who was able to wield the Dragon Slayer magic. With his "
	    put "incredible power and skill he was able to turn the tide of war and defeat"
	    put "the Dragon King. Now, after 2000 years, the Dragon King has returned, weaker,"
	    put "but still able to terrorize the land of Ryengard. Yojus Thane (you) has been"
	    put "resurrected once again to fight this great evil."
	    delay (12000)                                                                   % a delay to give the user the time to read the prologue
	    cls                                                                             % clearing the screen
	    Text.Color (4)                                                                  % Setting the text color to green
	    put "You have awoken in the Graveyard of Legends. There are 4 paths all around you,"    %Information about the world
	    put "each heading to one of the compass directions."
	    put skip
	    loop
		%Here, I tell the player about the world and the map, giving them instructions on how to play the game and how to exit the game
		%This is also the center stage from where you access all the other stages.
		
		put " To the North is the Volcanos of the King. The Dragon King and his royal minions" 
		put " reside there. To the East is the Ancient Forest, filled with unpleasant beasts"
		put " and to the west is the Ancient Ruins, home to the legendary Guardians of the"
		put " Ruins. To the south is the peaceful Town of Bardier. There you can buy items"
		put " and get treated for your wounds.(To select where you want to go, just type in"
		put " direction (e.g north, south, east, west) to go to that location and if you"
		put " want to leave the game, just type in quit at the Graveyard of Legends. Also"
		put " when in the other parts of the game, just enter the corresponding number"
		put " of the option you would like to choose."
		put skip
		put "Where would you like to go?"                      % Asking for user input on where they would like to go and storing it in the variable sdirection
								       % the get sdirection :8 means getting all the input on that line and storing it in a 
								       % string.
		get sdirection : *
		sdirection := Str.Lower (sdirection)                   % Having all the input be lowercase so thar it is easier to work with and sort
		cls                                                     
		case sdirection of                                     % Checking where the player would like to go.
			%---------------------- {The Volcanoes of the King} --------------------------------------------------------------------------------

		    label "north", "go north" :                         % If the player wants to go north
			Text.Color (7)          %Setting the text color to black
			
			% Underneath is a description of the Doors of the End. These doors are basically there to block the player from entering this stage because
			% they do not have the required items. 
			
			put "There is a large, looming gate in front of you. Beyond it, you can see the"
			put "mountains of ash and molten rock. The gate is made of solid gold and seems"
			put "unbreakable. There is a lock with three oddly shaped holes in them. It"
			put "looks like you need the three keys of the Guardians to enter, the Abyss"
			put "Stone, the Claw of the Blaze Fire Dragon and the Chilled Scale of Frosty."
			
			% Checking to see if the player has all the gate keys and telling them how to obtain the gate keys.
			
			if ai_gate_keys (4) = 1 then
			    if ai_gate_keys (5) = 1 then
				if ai_gate_keys (6) = 1 then
				
				% Here I check to see if the player has th proper armor set for this region since it is the last and the most dangerous one.
				% If they do not, then I warn them of their mistake. It is almost impossible to win without the Dragon Slayer Set.
				
				    if imaxhealth < 300 then
					put "It's dangerous to face the Dragon King at your level. It would be wise to get the"
					put "Dragon Slayer Armor."
				    end if
				    loop
				    
					%Description of this stage
				    
					put "As you gaze at the mountains of fire all around you, you notice that there are"
					put "two, very distinct paths laid out a bit away from you. One of them is made of"
					put "obsidian and leads to a huge black castle in the distance, the other seems to"
					put "lead to a valley below."
					put skip
					
					%Options for the player to pick to see which enemy they would like to face. Here, the player needs to defeat the subordinates
					% of the Dragon King to face him, thus, there is no initial third option.
					
					put "Which path would you like to take"
					put "(1) The path to the black castle."
					put "(2) The path to the valley."
					put "(3) Go back"
					get sfinal_decision                 %getting player input
					if sfinal_decision = "3" then       % This is if the player decides to leave, then clear the screen. This will be used later on
									    % as well, multiple times.
					    cls
					end if
					exit when sfinal_decision = "3"     % Exit when the player chooses 3
					case sfinal_decision of
					    label "1" :
						if ai_enemy_defeat_counter (7) = 1 then                 % This is to check if the player has already beaten this boss
						    put "You have already defeated the Draconic Prince."
						    delay (2000)
						    cls
						else
						
						    % Here, there is a description of the location and sets the enemy's health bar (imaxhealth2),  
						    % their strongest attack (istrong2) and their weakest attack (iweak2). This is for if the player ahs not
						    % defeated this boss yet.
						
						    stage_location := 7         
						    imaxhealth2 := 500      %Setting up the health
						    istrong2 := 100         %Setting up the strongest attack
						    iweak2 := 50            %Setting up the weakest attack
						    put "Down in the valley, there seems be a figure doing target practice on some rocks."
						    put "As you approach them, you see, the figure has large dark blue scales and white"
						    put "horns. It is the Draconic Prince, one of the top executive of the Dragon King."
						    put "He is as fierce as they say. You get ready for combat as you approach."
						    delay (1500)
						    put ""
						    
						    %Commencing Combat with the enemy
						    
						    COMBAT (istrong, istrong2, iweak, iweak2, imaxhealth, imaxhealth2, ienter, ihealth, ihealth2, iattack,
							iattack2, iresult, stage_location, icoins, iaction, ai_potions, ai_enemy_rewards_coins, scombat_decision, ai_gate_keys,
							ai_enemy_defeat_counter)
						end if
					    label "2" :
					    
						    %This follows the same procedure and steps as the previous one, setting up the enemy's attacks, health and
						    % checking to see if they have been defeated already.
						    
						if ai_enemy_defeat_counter (8) = 1 then
						    put "You have already defeated the Royal Advisor."
						    delay (2000)
						    cls
						else
						    stage_location := 8
						    imaxhealth2 := 400
						    istrong2 := 80
						    iweak2 := 60
						    put "As you approach the dark castle, it seems eerily quiet. It seems that the Dragon "
						    put "King is out for now. There are a set of large, granite doors ahead of you, they"
						    put "are closed but unlocked. As you open the doors you come to face the Royal Advisor"
						    put "of the King. He is the brains behind the King's Crusades in the past and it seems,"
						    put "he was revived with the King as well. He seems he was waiting for you. It's"
						    put "courteous to not keep him waiting."
						    delay (1500)
						    put ""
						    COMBAT (istrong, istrong2, iweak, iweak2, imaxhealth, imaxhealth2, ienter, ihealth, ihealth2, iattack,
							iattack2, iresult, stage_location, icoins, iaction, ai_potions, ai_enemy_rewards_coins, scombat_decision, ai_gate_keys,
							ai_enemy_defeat_counter)
						end if
					    label :
					end case
					if ai_enemy_defeat_counter (7) = 1 then
					    if ai_enemy_defeat_counter (8) = 1 then
					    
					    % If both the Royal Advisor and the Draconic Prince have fallen, then you will commence your fight with the Dragon King
					    % It gives a description of the final boss and sets up the bosses combat parameters
					    
						put "Seems like the Dragon King has finally noticed your presence. Get ready, the final"
						put "battle will begin soon."
						stage_location := 9
						ihealth := 300              % Resetting your health
						istrong2 := 200             % Resetting your attack(strong)
						iweak2 := 100               % Resetting your attack(weak)
						put "The Dragon King has landed in front of you. He is 9 stories tall and extremely"
						put "muscular. The region feels like it is heating up and feels more unbearable by the"
						put "second. There was a reason why he was and still is feared across the province of"
						put "Ryengard."
						delay (2000)
						COMBAT (istrong, istrong2, iweak, iweak2, imaxhealth, imaxhealth2, ienter, ihealth, ihealth2, iattack,
						    iattack2, iresult, stage_location, icoins, iaction, ai_potions, ai_enemy_rewards_coins, scombat_decision,
						    ai_gate_keys, ai_enemy_defeat_counter)
					    end if
					end if
				    end loop
				    
			   % Underneath, I tell the user which gate keys they are missing and as to why they cannot enter the final stage.
				    
				else
				    put "You need to defeat the Abyss Dragon and receive the Abyss Stone in order to proceed."
				    delay (2000)
				    cls
				end if
			    else
				put "You need the Chilled Scale of Frosty and the Abyss Stone to proceed."
				delay (2000)
				cls
			    end if
			else
			    put "You need the Claw of the Blaze Fire Dragon, the Chilled Scale of Frosty and the Abyss Stone to proceed."
			    delay (2000)
			    cls
			end if

			%---------------------- {The Town on Bardier} -----------------------------------------------------------------------------------------

		    label "south", "go south" :
			Text.Color (9)              % Setting the text color to blue
			
			%Underneath is a description fo this stage and gives the player the options on what needs to be done.
			
			put "You have entered the Town of Bardier. This town has been standing since"
			put "before the Great Dragon War. As per the name the founder was a warrior"
			put "and general named Bardier. It was a peaceful town back then, now it is"
			put "the heart of Ryengard. The ruler of this town is currently Lord Bahem."
			put "He has also given bounties on the beasts that live in the Ancient Forest."
			loop
			    %Giving the player the options to where to go
			    put "In front of you, there are three paths. To the right is the Blacksmith,"
			    put "to the left is the local hospital and forward is the alchemist."
			    put "(1) The Blacksmith"
			    put "(2) The Alchemist"
			    put "(3) The Hospital"
			    put "(4) Go back to the Graveyard of Legends"
			    get stown_location          %Retrieving player input and storing the data in the variable stown_location
			    cls
			    exit when stown_location = "4"  %exit this stage(loop) when the player has picked option 4, because stown_location is a string,
							    % the 4 is in quotations to show that it is a string.
			    case stown_location of
				label "1" :
				    %This is if the player picked the blacksmith. It gives them a brief description of the place.
				    loop
					put "You have entered the local Blacksmith shop. Here you can buy weapons and "
					put "armor, you can also re-wear old sets of armor if you so want.(To choose an"
					put "item, enter the corresponding number beside it.)"
					put "You have ", icoins, " gold coins."             %Showing the player how much money they have.
					put "(1) Beast Master Armor: 500 Gold Coins"        %Showing the prices for each item
					put "(2) Dragon Slayer Armor: 1000 Gold Coins"
					put "(3) Blinkstrike (Needle): 400 Gold Coins"
					put "(4) Dragon's Bane (Large Spear): 900 Gold Coins"
					put "(5) Go back to town square"                    %The option to go back
					Check_Int (inum, snum, bresult)         % Checking to see if the user inputted a valid integer
					iitem := inum
					if iitem = 5 then                       %If the player picked option 5, exit this level and clear the screen.
					    cls
					end if
					exit when iitem = 5
					for ishop : 1 .. 4                      % This is a for loop checking to see what item the user wants
					    if iitem = ishop then
						if ai_weapons_armor (ishop) = 1 then    % Checks to see if the user already owns the item
						    put "You already own this item"
						    put "Would you like to equip it?"   %Asks the user if they would like to change equipment
						    put "(1) Yes"
						    put "(2) No"
						    Check_Int (inum, snum, bresult) %Checking for valid integers
						    ioption := inum
						    if ioption = 1 then     %  If the user does want to wear that armor, set the 
									    % user's maximum health and attack parameters.
							case ishop of
							    label 1 :
								imaxhealth := 200       %Setting the health parameters
								put "You have put on the Beast Master Armor. You now have ", imaxhealth, " health points."
							    label 2 :
								imaxhealth := 300
								put "You have put on the Dragon Slayer Armor. You now have ", imaxhealth, " health points."
							    label 3 :
								istrong := 60       %Setting the strongest attack parameter
								iweak := 40         %Setting the weakest attack parameter
								put "You have equipped the Blink Strike Needle. You now have 60 attack points."
							    label :
								istrong := 200
								iweak := 100
								put "You have equipped the Dragon's Bane Spear. You now have 200 attack points."
							end case
							delay (1200)
							cls
						    end if
						else
						    if icoins >= ai_weapons_cost (ishop) then       %  If the player doesn't own the item, then the program
												    % checks to see if they have enough gold coin
												    
							icoins := icoins - ai_weapons_cost (ishop)  % If the player does have enough money, then the cost of the item
												    % is subtracted from the player's funds and the item is equipped automatically
												    
							ai_weapons_armor (ishop) := 1   % Marking the item the player bought as owned
							case ishop of
							    label 1 :
								imaxhealth := 200       %Setting the health bar
								put "You have put on the Beast Master Armor. You now have ", imaxhealth, " health points."
							    label 2 :
								imaxhealth := 300
								put "You have put on the Dragon Slayer Armor. You now have ", imaxhealth, " health points."
							    label 3 :
								istrong := 60
								iweak := 40
								put "You have equipped the Blink Strike Needle. You now have 60 attack points."
							    label :
								istrong := 200      %Setting the attack parameters
								iweak := 100
								put "You have equipped the Dragon's Bane Spear. You now have 200 attack points."
							end case
							delay (1200)
							cls
						    else
							put "Insuffecient Funds"        %If the player does not have enough money, the program outputs insuffecient funds.
							delay (500)
							cls
						    end if
						end if
					    end if
					end for
				    end loop
				label "2" :
				    loop
					%This is if the user has picked the alchemist shop. The program outputs a description of the level. 
					  
					put "This is the local Alchemost shop, home to the only alchemist in all of"
					put "Ryengard. As you enter, you catch a whiff of many different and strange"
					put "aromas. Here, you can buy ai_potions to aid you in battle."
					put ""
					put "You have ", icoins, " Gold Coins"      %Telling the user how many coins they have
					put "You have ", ai_potions (1), " Health ai_potions, ", ai_potions (2), " Attack Buff ai_potions and ", ai_potions (3) ..
					put " Armor Buff ai_potions."                                           %Telling the player how many of each potion do they own
					put "(1) Health Potion (Restores 50 Health Points): 200 Gold Coins"                 %Options for the potions
					put "(2) Armor Buff Potion (Increases total Health Points by 20): 300 Gold Coins"
					put "(3) Attack Buff Potion (Increases damage given by 20): 300 Gold Coins"
					put "(4) Go back to town square"
					put ""
					Check_Int (inum, snum, bresult)         %   Retrieving user input, checking to see if it is a valid integer and storing that
										% integer in the variable ipotion
					ipotion := inum
					if ipotion = 4 then         %If ipotion is 4, then exit this shop
					    cls
					else
					    if ipotion > 4 then     % if not, check for invalid entries
						put "The alchemist doesn't sell this non-existent potion, please pick another potion."
						delay (1500)
						cls
					    end if
					end if
					exit when ipotion = 4           % Telling the program to exit the shop when the user enters 4 because 4 is the option for 
									%going back
					
					for ipotion_counter : 1 .. 3        % A for loop that goes from 1 to 3 based on the options
					    if ipotion = ipotion_counter then   % Checking to see if the user input matched the option
						if icoins >= ai_potions_cost (ipotion_counter) then     %Checking to see if the user has enough money.
						    icoins := icoins - ai_potions_cost (ipotion_counter) %If they do, then subtract that amount from the player's funds
						    ai_potions (ipotion_counter) += 1       % Add 1 to the number of potions the user owns, for that specific potion.
						else
						    put "Insuffecient Funds"    %If the user doesn't have enough money, then output insuffecient funds.
						    delay (800)                 %Delay a bit so that the player can read the text.
						end if
						cls
					    end if
					end for
				    end loop
				label "3" :
				    % This is if the player has picked the hospital to heal themselves.
				    put "You have entered the local hospital."
				    put "You have ", icoins, " Gold Coins."             %Checking to see how many coins the user has
				    put "To get treated, you have to pay 400 coins."    %Telling the user the hospital fees
				    put "Your Health ", ihealth, "/", imaxhealth        %Telling you how much health you have and tells
											%you if you need to get healed or not.
											
				    put "(1) Get treated"                               % Gives the user the option to get treated.
				    put "Enter any other key to go back."               % The option to go back
				    Check_Int (inum, snum, bresult)             % Retrieving valid user input
				    itreatment := inum                          
				    case itreatment of                          % Checking to see which option the user picked
					label 1 :                           % If the user wants to get healed
					
					    if ihealth = imaxhealth then        % First the program checks how much health the user has, if they have full health
										% (ihealth = imaxhealth), the program outputs that you are fine and doesn't heal you.
						put "You are completely fine, don't waste your money."
						delay (1500)
						cls
					    else
						if icoins < 400 then            % If the player really does need their wounds treated, then the program checks to see
										% how much money the player has, if it is insuffecient, the game character does not
										% get healed.
						    put "Insuffecient funds"
						else
						    icoins := icoins - 400      % If the player does have enough money, the cost is subtracted from the
										% player's funds and the player restores full HP, no matter hwo large the heath
										% bar is.
						    ihealth := imaxhealth
						    put "You have been treated for your wounds. You now have ", ihealth, "/", imaxhealth, " HP." 
						    % Tells the user they have been healed
						    delay (1500)
						    cls
						end if
					    end if
					label :
					    put "You have left the hospital."
				    end case
				label :
			    end case
			end loop    %End of Stage 2
			%---------------------- {The Ancient Forest} ----------------------------------------------------------------------------------------------
		    label "east", "go east" :
			Text.Color (10)
			
			% This follows the same procedure as the northern stage. The main difference is how the enemies always respawn.
			% Underneath is a description of the region and gives the player the options on which monster to fight for money
			
			put "You have entered the Ancient Forest. All around you, you can hear the"
			put "snarls and the roars of the ferocious beasts that lurk within. As you"
			put "steel your nerves, you see a sign post in front of you. It points in"
			put "three directions, warning the locals and the hunters of where each"
			put "great beast inhabits. Also on the sign post, there are the rewards for"
			put "conquering each beast, courtesy of Lord Bahem, the king of the"
			put "Town of Bardier."
			put ""
			loop
			    put "You currently have ", icoins, " gold coins"        % Telling the user how much money they have
			    put "(1) Southeast (The Great Bears - 80 Gold Coins)"   % Option 1
			    put "(2) Northeast (Ogres - 120 Gold Coins)"            % Option 2
			    put "(3) East (Trolls - 180 Gold Coins)"                % Option 3
			    put "(4) Back to the Graveyard of Legends"              % Allowing the player to head back
			    put ""
			    Check_Int (inum, snum, bresult)             % Checking for a valid user input
			    stage_location := inum
			    if stage_location = 4 then              % Telling the program to clear the screen when the user leaves this stage and to leave the
								    % stage(loop) when the user picks option 4.
				cls
			    end if
			    exit when stage_location = 4
			    case stage_location of          % Setting the combat parameters for the monsters based on which monster the user chose.
				label 1 :                   
				    imaxhealth2 := 80
				    istrong2 := 20
				    iweak2 := 5
				label 2 :
				    imaxhealth2 := 100
				    istrong2 := 20
				    iweak2 := 10
				label 3 :
				    imaxhealth2 := 110
				    istrong2 := 20
				    iweak2 := 10
				label :
				    put "Error"
			    end case
			    %Commencing Combat procedure
			    COMBAT (istrong, istrong2, iweak, iweak2, imaxhealth, imaxhealth2, ienter, ihealth, ihealth2, iattack, iattack2, iresult,
				stage_location, icoins, iaction, ai_potions, ai_enemy_rewards_coins, scombat_decision, ai_gate_keys, ai_enemy_defeat_counter)
			end loop
			%---------------------- {The Ancient Ruins} ------------------------------------------------------------------------------------------
		    label "west", "go west" :
			if imaxhealth >= 200 then           %Checking to see if you have the Beast Master Armor On(atleast have your health above 200)
			    if istrong >= 60 then           %Checking to see if you have the Blinkstrike equipped(atleast have your strongest attack be above 60)
				Text.Color (19)             %Setting text color to light grey
				loop
				
				    %Location description and giving the user the option to pick where they would like to go. Each location has a boss.
				    
				    put "You enter the Ancient Ruins. Long ago, this used to be a prosperous city"
				    put "in which Dragons and Humans co-existed in peace. Now, it is a memory"
				    put "long forgotten. The region is deserted and there is an eerie fog that"
				    put "sticks to the ground. The place is true to it's name. There are burned"
				    put "down huts and ruins of the ancient civallization. As you approach the"
				    put "city, you can make out three roads, each leading in a different"
				    put "direction. There is a sign post even amongst all the rubble that tells"
				    put "you where each road leads to. There also seems to be some deep gashes"
				    put "on the stone pathway."
				    put "(4) The old graveyard"
				    put "(5) Left Path"
				    put "(6) The burned town hall"
				    put "(7) Back to the Graveyard of Legends"
				    put ""
				    Check_Int (inum, snum, bresult)         % Checking for valid user input
				    stage_location := inum
				    cls
				    if stage_location = 7 then              %Clear the screen if option 7 is picked
					cls
				    else
					if stage_location > 6 then              % If an unknown option is picked, tell the user it is not possible
					    put "That option doesn't exist."
					else
					    if stage_location < 4 then          % Checking to see for invalid entries on option numbers
						put "There is no such path."
					    end if
					end if
				    end if
				    exit when stage_location = 7                %Exit this stage/loop when the player picks option 7
				    for icounter : 4 .. 6                       % A for loop to check to see if the location picked has been already compleated.
					if stage_location = icounter then       % This is to get to the right location
					    if ai_enemy_defeat_counter (icounter) = 1 then      % Checking to see if the location picked is completed or not
						put "You already slain this enemy. There is nothing interesting here now."
						cls
					    else
						case stage_location of          % If the enemy has not been defeated, then the program will set the enemy's
										% combat parameters and give the player a description and a prologue to the fight
						    label 4 :
							imaxhealth2 := 200      % Setting combat parameters
							istrong2 := 40
							iweak2 := 15
							put "As you approach the old graveyard, there is this uneasy feeling that"      % Prologue to the fight.
							put "goes down your spine. Suddenly, you hear rough breathing behind you."
							put "You turn around and come face to face with the Black Dragon of the "
							put "Abyss. One of the three Guardians. He seems like he is ready for a "
							put "fight."
							delay (4000)
						    label 5 :
							imaxhealth2 := 250  % same procedure as label 4
							istrong2 := 30
							iweak2 := 15
							put "The path to the left leads you to the city center. There is a huge "
							put "fountain there but it is frozen. Atop it, there is Frosty, the Ice"
							put "Dragon. He holds the Chilled scale of Frosty, one of the keys needed"
							put "to open the Gates of the End. You get ready to fight Frosty as he takes"
							put "notice of you."
							delay (4000)
						    label 6 :
							imaxhealth2 := 300  % same procedure as label 4
							istrong2 := 50
							iweak2 := 20
							put "You approach the old town hall. It has been burned down to the ground."
							put "You notice a large figure laying down in the center of the hall. As you"
							put "get closer, the figure reveals it self to be the Blaze Fire Dragon. He "
							put "is the most ferocious of the 3 Guardians. You get ready for the fight to"
							put "come as he approaches you, claws raised."
							delay (4000)
						    label :
						end case
						%Initiating Combat Procedure
						COMBAT (istrong, istrong2, iweak, iweak2, imaxhealth, imaxhealth2, ienter, ihealth, ihealth2, iattack, iattack2,
						    iresult, stage_location, icoins, iaction, ai_potions, ai_enemy_rewards_coins, scombat_decision, ai_gate_keys,
						    ai_enemy_defeat_counter)
					    end if
					end if
				    end for
				end loop        %ending the stage
			    else
				put "You don't have the Blinkstrike."       %Telling the user what is required to enter
			    end if
			else
			    put "You don't have the Beast Master Armor. To enter, you need to have both the Beast Master Armor"
			    put "and the Blinkstrike."
			end if
			put "Going back to the Graveyard of Legends."   %A message to the player to tell them where the game character is being taken.
			delay (1000)
			cls
		    label "quit" :
			cls
			View.Set ("graphics")
			Font.Draw ("Thanks For Playing!", 150, 200, itext2, black)
			delay (2000)
			cls
			bfinish := true
		    label :
		end case
		exit when bfinish = true
	    end loop
	    %---------------------------------- {Game End}  -----------------------------
	label "2" :
	    
	    % This is a help menu filled with instructions that tell the player how to play the game. If the player does nto pick 2 for the help menu and gets
	    % straight into the game, even so, the user gets all the instructions whenever they visit the Graveyard of Legends
	
	    put "This game is multiple choice based. Most of the time, all you have to do"
	    put "is type in the number of the corresponding option. For the navigation"
	    put "system however, from the Graveyard of Legends to the other locations, all"
	    put "you need to do is type in the direction you want to go."
	    put "(e.g north, go south etc.)."
	    put skip
	label :         %If an invalid input is entered, the screen just resets
	    cls
    end case
end loop %End of the game
%TYFUMP




