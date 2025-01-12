extends Node
class_name B2_ClockTime

## B2_ClockTime - Helper class to progress, check, modify and alter the game´s time.

## Constants
const EXPERIENCE_MIN 	:= 0.5
const EXPERIENCE_MAX 	:= 1.5
const CLOCK_MAX 		:= 60.0 * 60.0 * 24.0 ## NOTE Seems like the maximun play time.
const CLOCK_SPEED 		:= 4.0 ## EDITABLE: If you are 1 gate away, it will start at 4 seconds and taper down

enum EVENTS{TIMER, QUEST, VALUE}

## Gets current time "gate". what is a time gate? who knows?
static func time_gate() -> int:
	return int( B2_Config.get_user_save_data("clock.gate", 0.0) ) ## Should always be an INT
	
## get current time, between 0.0 and 24.0
static func time_get() -> float:
	return snapped( ( 24.0 - ( B2_Config.get_user_save_data("clock.time", 0.0) / 3600.0 ) ), 0.1 )
	
## DEBUG Change current time
static func time_set( time : float ):
	B2_Config.set_user_save_data("clock.time", time);
	
static func time_init() -> void:
	## Clock
	B2_Config.set_user_save_data("clock.time", CLOCK_MAX);
	B2_Config.set_user_save_data("clock.gate", 0.0);
	
	## NOTE Changed the code below. Instead of 3 vars, we'll use only one.
	#B2_Config.set_user_save_data("clock.event.timer", Array() )
	#B2_Config.set_user_save_data("clock.event.quest", Array() )
	#B2_Config.set_user_save_data("clock.event.value", Array() )
	B2_Config.set_user_save_data("clock.event", Array() ) ## format -> [timer, quest, value]
	
## This just spits the current time in string format.
static func time_display( my_time = null ) -> String:
	var clockTime = B2_Config.get_user_save_data( "clock.time", 0.0 )
	if my_time != null:
		clockTime = my_time
		
	var clockSeconds 	= floor( int(clockTime) % 60)
	var clockMinutes 	= clockTime / 60.0
	var clockHours 		= clockMinutes / 60.0
	clockMinutes 		= int(clockMinutes) % 60
	
	return str( round(clockHours) ) + ":" + str( round(clockMinutes) )
	
## Set a timed event. After the timer runs out, change a quest variable.
static func time_event( quest, value, timer ) -> void: # timer is in seconds.
	## Get current events from memory
	var curr_events : Array = B2_Config.get_user_save_data("clock.event", Array() )
	
	if value is String:
		if not value.is_valid_float() and not value.is_valid_int():
			push_error("Value is not an actual usable value.")
			breakpoint
			
	if timer is String:
		if not timer.is_valid_float() and not timer.is_valid_int():
			push_error("Timer is not an actual usable value.")
			breakpoint
			
	value = float(value)
	timer = float(timer)
	
	## Format my event.
	var my_event := Array()
	my_event.resize(3)
	my_event[EVENTS.TIMER] = round(timer * 60.0)	# [0]
	my_event[EVENTS.QUEST] = quest 					# [1]
	my_event[EVENTS.VALUE] = value 					# [2]
	## NOTE This is weird. the comment tell us that "timer" should be in secconds and then, multiplies by 60 to get minutes?
	curr_events.append( my_event )
	
	## Save my event to the current list.
	B2_Config.set_user_save_data("clock.event", curr_events )
	print_rich( "[color=magenta]B2_ClockTime Event set -> [b]%s[/b].[/color]" % my_event[EVENTS.QUEST] )
	
## Step is pretty important. It updates the time and shit.
static func time_step( step : float ) -> void:
	## NOTE Ignoring all code related to "DeathClock".
	## NOTE check ClockTime() line 84
	
	#if get_tree().paused:
	#	push_error("Updating timer while paused.")
	#	breakpoint
	
	time_process(step)
	
	
# Update timed quest events
static func time_process( step : float ) -> void:
	var clockTime = B2_Config.get_user_save_data("clock.time")
	clockTime -= step
	B2_Config.set_user_save_data("clock.time", clockTime)
	
	var events : Array = B2_Config.get_user_save_data( "clock.event", Array() )
	var processed_events := Array()
	
	## Process events
	for ev : Array in events:
		ev[EVENTS.TIMER] -= 1.0
		
		## If timer reached zero, "Do the will of the event".
		if ev[EVENTS.TIMER] <= 0.0:
			var quest = ev[EVENTS.QUEST]
			var value = ev[EVENTS.VALUE]
			B2_Playerdata.Quest( quest, value )
		else:
			processed_events.append( ev )
			
	## Save processed events
	B2_Config.set_user_save_data("clock.event", processed_events )
	
	time_update( step )

static func time_update( _step : float ) -> void:
	var clockTime = B2_Config.get_user_save_data("clock.time")
	
	var clockSeconds 	= floor( int(clockTime) % 60)
	var clockMinutes 	= clockTime / 60.0
	var clockHours 		= clockMinutes / 60.0
	clockMinutes 		= int(clockMinutes) % 60
	
	var clockGate = abs(ceil( clockHours + 1 ) - 24);
	B2_Config.set_user_save_data("clock.gate", clockGate )
