extends Node

@onready var pre_shooting_timer		: Timer = $pre_shooting_timer	## Timer used when a gun need some time before firing (muskets)
@onready var firing_rate			: Timer = $firing_rate			## Timer used to control the firing rate
@onready var post_shooting_timer	: Timer = $post_shooting_timer	## ## Timer used when a gun need some time after firing

## Node used to interface the player with its gun.
