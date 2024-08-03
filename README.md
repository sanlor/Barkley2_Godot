This is a personal project, trying to port the unfinished game Barkley2 to Godot.
I just want to dig through the barkley 2´s code, learn a few things about gamedev. My plan is to be able to make an exact copy of the janky demo: https://talesofgames.itch.io/barkley-2
#### NOTE - As of the time of this writing, this port is not cannon. Sorry.


# Stage 0 - AN OLD PROMISSE.........FORGOTTEN.
( Recreate the title screen, with all original features. Also scrate some autoload to start laying the groundwork for the game )
  - [x] Migrate important scripts and objects to Godot´s autoloads
	- [x] Migrate the Audio() Script, responsible for the Music -> 25% done
	- [x] Migrate the Sound() Script, responsible for the Sfx -> 50% done
	- [x] Migrate the Border() Script, responsible for the panel, windows, buttons and dialog boxes.
	  - [x] Generate the panel, with its "random" border decorrations
	- [x] Migrate the oConfirm object
	- [ ] TBD

  - [x] Recreate all of the game´s fonts. The original font is just a bunch of animated sprites.
  - [x] Recreate the game´s cursor.
	- [x] Add the blinking animation
	- [x] Add the "blur" when you move it too fast.
  - [ ] Recreate the game´s title screen
	- [x] Add Ziggurat, bobing up and down
	- [x] Add other decorations, with their own animations
	- [x] Add the BARKLEY2 Logo
	- [x] Add the Janky Demo logo
	- [x] Add the "panel" fort the main menu buttons
	- [x] Add the Game Time, Settings, Quit buttons
	- [x] Add Saved Game Slots
	  - [x] Add saving capabilities, compatible with the original´s game save file ## Cant test, but is should be compatible
	  - [x] Add loading capabilities, compatible with the original´s game save file
		- [x] Add the 3 Options, but dont do anything after that.
		- [x] Add the return Button
	- [ ] Add Settings Window
	  - [x] Add General Tab
		- [x] Add Working Music Slider
		- [x] Add Working Sound Slider
		- [x] Add Filter Option
		  - [ ] Add Working filters ## CRT is the only one working. Even that ist all that good.
		- [x] Add Joke´s option, along wit its functionality (no idea what it does)
		- [x] Add Working language option # Ym Prat myhkiyka yttat, Bnaddo cina huputo ajah kuehk du ica ed.
		- [x] Add Working Fullscreen option
		- [x] Add Working Scaling option
	  - [x] Add Controls Tab
		- [x] Add all key actions, along with remapable keys
	  - [x] Add Gamepad Tab
		- [ ] Add all key actions, along with remapable keys
	  - [x] Add Working Return Key
	  
# Stage 1 - BROKEN AND BURIED ON A OPEN GRAVE
( Recreate the Character Creation - CC )
- [x] o_cc_name
	- [x] Dialog pre input
	- [x] Input
- [x] o_cc_zodiac
	- [x] Dialog pre input
	- [x] Input
	- [x] Huge Dialog
- [x] o_cc_blood
- [x] o_cc_gender
- [x] o_cc_alignment
- [x] o_cc_death
- [x] o_cc_crest
- [x] o_cc_tarot
- [x] o_cc_gumball
- [x] o_cc_placenta
	- [x] o_cc_rune
	- [x] o_cc_hand_scanner
	- [x] o_cc_inkblots
	- [x] o_cc_multiple
	- [x] o_cc_palm_reading
	- [x] o_cc_lottery
	- [x] o_cc_likes_favorites
- [x] o_cc_finish
- [x] Add a room to inform the player of the game´s end ( r_wip )
- [x] Setup the save system to work correctly
- [x] General bugfixes

# Stage 2 - FORGOTTEN.........FORSAKEN.........
( Recreate the Egg Room ONLY. Lay the groundwork for the tutorial. Make a cinematic system and dynamic dialog boxes. )

- [x] Migrate to Godot 4.3 ( Only the RC1 is available rn )

> [!NOTE]
> Discover what else need to be migrated.
