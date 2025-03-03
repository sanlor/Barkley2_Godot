This tries to replicate the original cinema system. No Idea how, to be honest.
24-02-25 - I have some idea how, now.

## B2_Script_Legacy
Simulates the old Cinema system.
Its a huge text file, parsed line by line, with commands and parameters separated by "|".
Ex.: DIALOG | Christina | `w2`What am I gonna do?`w0`

## B2_ScriptActions
Parent class of the new system, mostly used by the combat system right now. DEPRECATED

## B2_Script_Combat
System mostly copied from B2_Script_Legacy. Used only for combat initiation and finish (Like, moving combatants to its initial positioning).

## combat_cinema.gd
Important! Manages the combat cinema actions

## combat_manager.gd
Duh, its the manager for the actual combat. It needs the ui_combat_module.gd (combat UI) script to work.
