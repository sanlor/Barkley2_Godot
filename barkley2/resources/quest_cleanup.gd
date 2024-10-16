extends Node
class_name B2_QuestCleanup

enum OP{EQUAL,NOT_EQUAL,GREATER,LESSER,GREATER_EQUAL,LESSER_EQUAL}
enum ACT{DESTROY, LOG, DESTROY_AND_LOG}

@export var quest_name 	:= ""
@export var compare		:= OP.GREATER
@export var value		:= 0
@export var action		:= ACT.DESTROY


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
			ACT.DESTROY:
				get_parent().queue_free()
			ACT.LOG:
				print("%s was removed due to a quest flag. %s - %s" % [get_parent().name, quest_name, str(value)])
			_:
				print("%s was removed due to a quest flag. %s - %s" % [get_parent().name, quest_name, str(value)])
				get_parent().queue_free()
