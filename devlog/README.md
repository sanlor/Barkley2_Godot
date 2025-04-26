22/06/24
Project start. 
Today I started by creating a Win 7 VM, downloading lots of sketchy versions of Gamemaker Studio 1.4 (I actually have a valid license, but the support from
GMS told me that they cant provide a downoad link anymore).
I can open and run the game from the editor, so now I can start my work. Instead of jumping in without a plan, I decided to plan and define an initial scope.
good work for today. 

23/06/24
reading and understanding scripts. some people poured a lot of love and effort on this game. the Cinema script is very impressive.
Really hope I can make this work on Godot.
...
Neat. The title is starting to look right. I basically just copied some code, and everything worked.
One funny thing was that some values needed a bit of tweaking. The screen resolution should be the same, maybe the way stuff are drawn to the screen is the issue?
On the title screen, there are those litthe stars (oTitleStarpass), i just copied the code, pasted and it worked. That makes me pretty confident about this project.

Now, here is a big problem: fonts. Barkley2 uses spritefonts and Im having a hard time finding a way to use it on godot.
Converting it to standart font is also hard... No idea what to do. scrath that, just figured out.
Basically I used a program called http://www.rw-designer.com/image-grid and made a big PNG file, and godot can read it.
check res://barkley2/assets/fonts/f_fn1.png
The font reminds me a big if the Terranigma font: https://www.spriters-resource.com/snes/terranigma/sheet/35455/

My Border() Script is half baked. Need to fix it soon to write dialog.

24/06/24
Uploaded the original code to github and done some documentation,

27/06/24
Migrated the main menu and part of the settings menu. Just copying code around. No Idea how far cain I take this method.
Font issue is back. Cant ise the monospaced font that I came up with it. Still, not sure what I will do.

30/06/24
Font issue is mostly solved. Had to install a plugin to make it work. The plugin itself doesnt work perfectly, but it does its job (along with spitting lots of errors).
Title screen is going OK. Once the graphics are done, Im going to start working on the audio.
