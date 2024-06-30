This is a personal project, trying to port the unfinished game Barkley2 to Godot.
I just want to dig through the barkley 2´s code, learn a few things about gamedev. My play is to be able to make an exact copy of the janky demo: https://talesofgames.itch.io/barkley-2

# Stage 0 - Recreate the title screen, with all original features:
  - [ ] Migrate important scripts and objects to Godot´s autoloads
	- [ ] Migrate the Audio() Script, responsible for the Music
	- [ ] Migrate the Sound() Script, responsible for the Sfx
	- [ ] Migrate the Border() Script, responsible for the panel, windows, buttons and dialog boxes.
	  - [ ] Generate the panel, with its "random" border decorrations
	- [ ] TBD
> [!NOTE]
> Discover what else need to be migrated.

  - [ ] Recreate all of the game´s fonts. The original font is just a bunch of animated sprites.
  - [ ] Recreate the game´s cursor.
	- [ ] Add the blinking animation
	- [ ] Add the "blur" when you move it too fast.
  - [ ] Recreate the game´s title screen
	- [x] Add Ziggurat, bobing up and down
	- [x] Add other decorations, with their own animations
	- [x] Add the BARKLEY2 Logo
	- [x] Add the Janky Demo logo
	- [x] Add the "panel" fort the main menu buttons
	- [ ] Add the Game Time, Settings, Quit buttons
	- [ ] Add Saved Game Slots
	  - [ ] Add saving capabilities, compatible with the original´s game save file
	  - [ ] Add loading capabilities, compatible with the original´s game save file
		- [ ] Add the 3 Options, but dont do anything after that.
		- [ ] Add the return Button
	- [ ] Add Settings Window
	  - [ ] Add General Tab
		- [ ] Add Working Music Slider
		- [ ] Add Working Sound Slider
		- [ ] Add Filter Option
		  - [ ] Add Working filters
		- [ ] Add Joke´s option, along wit its functionality (no idea what it does)
		- [ ] Add Working language option
		- [ ] Add Working Fullscreen option
		- [ ] Add Working Scaling option
	  - [ ] Add Controls Tab
		- [ ] Add all key actions, along with remapable keys
	  - [ ] Add Gamepad Tab
		- [ ] Add all key actions, along with remapable keys
	  - [ ] Add Working Return Key
	  
# Stage 1 - Recreate the Tutorial
  - [ ] TBD

