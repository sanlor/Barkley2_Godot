extends Node
class_name B2_DoorLocker

enum OP{EQUAL,NOT_EQUAL,GREATER,LESSER,GREATER_EQUAL,LESSER_EQUAL}
enum ACT{LOCK, UNLOCK, LOCK_AND_LOG, UNLOCK_AND_LOG}

@export var quest_name 	:= ""
@export var compare		:= OP.GREATER
@export var value		:= 0
@export var action		:= ACT.LOCK
@export_multiline var comments : String

func _ready() -> void:
	var q = B2_Playerdata.Quest(quest_name, null, 0)
	var m := false
	match compare:
		OP.EQUAL:
			m = q == value
		OP.NOT_EQUAL:
			m = q != value
		OP.GREATER:
			m = q > value
		OP.LESSER:
			m = q < value
		OP.GREATER_EQUAL:
			m = q >= value
		OP.LESSER_EQUAL:
			m = q <= value
			
	if m:
		match action:
			ACT.LOCK:
				lock()
			ACT.UNLOCK:
				unlock()
			ACT.LOCK_AND_LOG:
				lock()
				print_rich("%s was [b]locked[/b] due to a quest flag. %s - %s" % [get_parent().name, quest_name, str(value)])
			ACT.UNLOCK_AND_LOG:
				unlock()
				print_rich("%s was [b]unlocked[/b] due to a quest flag. %s - %s" % [get_parent().name, quest_name, str(value)])
			_:
				breakpoint
	# remove myself
	queue_free()

func lock() -> void:
	if get_parent() is B2_DOOR_PARENT:
		get_parent().locked = true
		
func unlock() -> void:
	if get_parent() is B2_DOOR_PARENT:
		get_parent().locked = false
