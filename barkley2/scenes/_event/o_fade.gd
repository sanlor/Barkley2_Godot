extends ColorRect
#check the original o_fade object.

## Automatically called when a fade object is created.

# The event that is associated with this fade object, should never be null.
var _event 			= null;
# True if it should fade out, false if it should fade in.
var _fade 			:= true;
# The amount of seconds for this object to fade.
var _seconds 		:= 1.0; # was 0.0
# Short delay at the apex of the fade //  LAZ TEST // Purpose: remove those 1 frame long flashes of no-fade-effect
var _fadeDelay 		:= 1.0;
# Color of the fade //
var _fadeColor 		:= Color.BLACK;

func _ready() -> void:
	assert( _event != null, "_event should never be null." )
	_event.created_new_fade.connect( queue_free )
	_event.tree_exiting.connect( queue_free )
	
	color = _fadeColor
	
	var target_alpha : float
	if _fade:
		color.a = 0.0
		target_alpha = 1.0
	else:
		color.a = 1.0
		target_alpha = 0.0
		
	if _seconds > 0.0:
		var tween := create_tween()
		tween.tween_property(self, "color:a", target_alpha, _seconds)
		if _fade == true:
			tween.tween_interval( _fadeDelay )
		#tween.tween_callback( queue_free )
	else:
		color.a = target_alpha
		print("permanent fade created: ", self)
