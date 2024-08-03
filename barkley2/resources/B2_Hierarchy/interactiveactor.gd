extends B2_Actor
class_name B2_InteractiveActor

# scr_event_interactive_init()
# Automatically called by the InteractiveActor upon creation.

# event_inherited();

var _state = 0;
var _variables = Dictionary() # ds_map_create();
var _started = false;
var _autoDraw = true;
var _selectedOutline = false;
var _disableOutline = false;
var _active = true;
#var _pedestrian = false;
var _duergar = false; # For draw, but can be used for other things later

# True if you can interact with this event.
var _interactive = true;
var _interactive_timer = 0;
var _interactive_distance = null # global.settingInteractiveDistance; # GZ: The max distance you can be to click this

# True if the sprite is using automatic animations (like when it is moving), or false otherwise.
var _automatic_animation = false;
# The animation to use if automatic animation isn't true. 
var _current_animation = null # ANIMATION_DEFAULT;
#scr_entity_animation_setSpriteIndex(ANIMATION_DEFAULT, sprite_index);
#scr_entity_animation_setSpeed(ANIMATION_DEFAULT, ANIMATION_DEFAULT_SPEED);
#scr_entity_set_walk(sprite_index, sprite_index, sprite_index, sprite_index, sprite_index, sprite_index, sprite_index, sprite_index);

# GZ NOTE: Added exception variable so you can do special things with hard coded objects
var _exception = 0;

# The last direction this actor was in.
var _last_direction = null # RIGHT;
var _last_frame = 0; # For draw event

# Used for camera following.
var camera_target_x = null # x;
var camera_target_y = null # y;
var camera_speed = 32;

# Walk animation constants
#walk_animation[0] = ANIMATION_EAST;
#walk_animation[1] = ANIMATION_NORTHEAST;
#walk_animation[2] = ANIMATION_NORTH;
#walk_animation[3] = ANIMATION_NORTHWEST;
#walk_animation[4] = ANIMATION_WEST;
#walk_animation[5] = ANIMATION_SOUTHWEST;
#walk_animation[6] = ANIMATION_SOUTH;
#walk_animation[7] = ANIMATION_SOUTHEAST;

# Edit for strips
#sprite_width_edit = sprite_width;
#sprite_height_edit = sprite_height;

# InteractiveActors are rigid by default
#scr_actor_setRigid(id)

# Specify defaults for all of the Event Hooks
#scr_event_hook_onStart(NULL);
#scr_event_hook_onInteract(NULL);
#scr_event_hook_onCollision(NULL);

var script_start = "";
var xFlip = 0; # Only used for Thrax scene, can be used to override image_xscale
