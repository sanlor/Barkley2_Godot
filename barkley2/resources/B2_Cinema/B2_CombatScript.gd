extends Resource
class_name B2_CombatScript

enum ACTIONS{LOOK_AT,MOVE_TO,JUMP_TO,PLAY_ANIM,PLAY_SOUND,WAIT,START_BATTLE}
# LOOK_AT - Actor lokk to a specific direction
# MOVE_TO - Actor moves to a position
# JUMP_TO - Actor jumps and moves to a specific position
# PLAY_ANIM - Actor plays an animation
# PLAY_SOUND - Script plays a sound
# WAIT - Wait for a while
# START_BATTLE - Start the battle. Should always end with this.

enum TARGET{NONE,ACTOR,CAMERA}

@export var combat_actions : Array[B2_CombatScriptActions]
