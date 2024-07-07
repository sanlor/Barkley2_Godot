This is a personal project, trying to port the unfinished game Barkley2 to Godot.
I just want to dig through the barkley 2´s code, learn a few things about gamedev. My play is to be able to make an exact copy of the janky demo: https://talesofgames.itch.io/barkley-2

# Stage 0 - Recreate the title screen, with all original features:
  - [ ] Migrate important scripts and objects to Godot´s autoloads
	- [ ] Migrate the Audio() Script, responsible for the Music -> 25% done
	- [x] Migrate the Sound() Script, responsible for the Sfx -> 50% done
	- [x] Migrate the Border() Script, responsible for the panel, windows, buttons and dialog boxes.
	  - [ ] Generate the panel, with its "random" border decorrations
	- [ ] TBD
> [!NOTE]
> Discover what else need to be migrated.

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
	  - [ ] Add saving capabilities, compatible with the original´s game save file
	  - [ ] Add loading capabilities, compatible with the original´s game save file
		- [x] Add the 3 Options, but dont do anything after that.
		- [x] Add the return Button
	- [ ] Add Settings Window
	  - [x] Add General Tab
		- [x] Add Working Music Slider
		- [x] Add Working Sound Slider
		- [x] Add Filter Option
		  - [ ] Add Working filters
		- [x] Add Joke´s option, along wit its functionality (no idea what it does)
		- [x] Add Working language option
		- [x] Add Working Fullscreen option
		- [x] Add Working Scaling option
	  - [x] Add Controls Tab
		- [x] Add all key actions, along with remapable keys
	  - [x] Add Gamepad Tab
		- [ ] Add all key actions, along with remapable keys
	  - [x] Add Working Return Key
	  
# Stage 1 - Recreate the Tutorial
  - [ ] TBD

