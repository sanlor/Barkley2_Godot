extends Node
## Autoload used to manage signals.
# Created on 08/08/25

## HUD inform nodes that the hud is shown or not
signal hud_visibility_changed

## Title screen. Notify a few nodes that the title screen is currently loaded.
# Very useful when quitting the game
signal title_screen_loaded

## Utility Station stuff
signal unpluged_from_station

## Player / Camera stuff (Was in B2_Input)
signal player_follow_mouse( enabled : bool )
signal camera_follow_mouse( enabled : bool )
signal player_input_permission_changed
signal player_is_aiming
signal player_stopped_aiming

## Room permisions
signal room_permission_changed
signal room_pacify_changed( activated : bool )

### Combat
## Hoopz events (Was in B2_CManager)
signal hoopz_got_hit ## Used during combat, for action canceling.
signal hoopz_was_killed ## Used for combat, to let the workd know that hoopz died.

## Gun events (Was in B2_PlayerData)
signal gun_changed			## Player selected a new gun
signal gun_owned_changed	## Player gained or lost a gun

## Quest events (Was in B2_PlayerData)
signal quest_updated

## PlayerStats events (Was in B2_PlayerData)
signal stat_updated( stat )
