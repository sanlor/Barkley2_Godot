This is a personal project, trying to port the unfinished game Barkley2 to Godot.
I just want to dig through the barkley 2´s code, learn a few things about gamedev. My plan is to be able to make an exact copy of the janky demo: https://talesofgames.itch.io/barkley-2
#### NOTE - As of the time of this writing, this port is not cannon. Sorry.


# Stage 0
Recreate the title screen, with all original features. Also create some autoload to start laying the groundwork for the game.
Basically, this is a proof of concept.
    
# Stage 1
Recreate the Character Creation - CC
This section of the game contains a BUNCH of legacy code. It wasnt hard, but took a long time.

# Stage 2
Recreate the Egg Room ONLY. Lay the groundwork for the tutorial. Make a cinematic system and dynamic dialog boxes.
This is the real chalenge. Not easy to recreate the way stuff works on GML using Godot.

# Stage 3
The work on the EggRoom laid the foundation for the restt of the project.
Stage 3 will try to port the entire tutorial. It will be split in parts:

- 3a - Port the r_fct_accessHall01 only
- 3b - Port the r_fct_tutorialZone01 only (And add the ability to roll)
- 3c - Forget the individual parts, just do the entire tutorial.

# Stage 3.1
Fix everything that is broken with Stage 3.

# Stage 4
No Idea, start with Wilmer house and see what happens.
