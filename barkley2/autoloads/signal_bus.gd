extends Node
## Autoload used to manage signals.
# Created on 08/08/25

## Player / Camera stuff (Was in B2_Input)
signal player_follow_mouse( enabled : bool )
signal camera_follow_mouse( enabled : bool )
signal player_input_permission_changed

## Room permisions
signal room_permission_changed
signal room_pacify_changed( activated : bool )

### Combat
## Hoopz events (Was in B2_CManager)
signal hoopz_got_hit ## Used during combat, for action canceling.
signal hoopz_was_killed ## Used for combat, to let the workd know that hoopz died.

## Gun events (Was in B2_PlayerData)
signal gun_changed

## Quest events (Was in B2_PlayerData)
signal quest_updated

## PlayerStats events (Was in B2_PlayerData)
signal stat_updated
