extends Control

signal thread_pressed( thread_name : String, thread_title : String )

const FORUM_DATA 		= preload("res://barkley2/resources/B2_DNET/forum_data.json")
const THREAD_PANEL 		= preload("res://barkley2/scenes/_utilityStation/dwarfnet/thread_panel.tscn")

@onready var thread_list: VBoxContainer = $ScrollContainer/MarginContainer/thread_list
@onready var scroll_container: ScrollContainer = $ScrollContainer

func clear_threads() -> void:
	for i in thread_list.get_children():
		i.queue_free()

func add_thread( thread_name : String, sticky := false ) -> void:
	var thread = THREAD_PANEL.instantiate()
	
	if FORUM_DATA.data.has( thread_name ):
		thread.thread_name			= thread_name
		thread.thread_icon 			= int( FORUM_DATA.data[thread_name].get("Sub",33) )
		thread.thread_title			= str( FORUM_DATA.data[thread_name].get("Title", "Missing Thread Title for '%s'." % thread_name) )
		thread.thread_poster		= str( FORUM_DATA.data[thread_name].get("Author", "Missing Thread poster for '%s'." % thread_name) )
		thread.is_sticky			= sticky # FORUM_DATA.data[thread_name].has("Sticky")
		thread.has_pool				= FORUM_DATA.data[thread_name].has("Pool")
		thread.is_locked			= false
		if FORUM_DATA.data[thread_name].has("Locked"):
			var lock_time : String = FORUM_DATA.data[thread_name].get("lockTime", "00:00")

			if B2_DNET.time_after( lock_time.get_slice(":",0) ):
				thread.is_locked			= true
				thread.thread_icon 			= 6
	else:
		thread.thread_icon 			= 33
		thread.thread_title			= "Invalid forum '%s'" % thread_name
		thread.thread_poster		= "PussySlayer69"
		thread.is_sticky			= false
		thread.is_locked			= false
		
	thread.button_pressed.connect( _thread_pressed.bind(thread_name, thread.thread_title) )
	thread_list.add_child( thread )

func _thread_pressed( thread_name : String, thread_title : String ) -> void:
	thread_pressed.emit( thread_name, thread_title )

func _on_visibility_changed() -> void:
	if visible:
		if thread_list.get_children().is_empty():
			scroll_container.get_v_scroll_bar().grab_focus()
		else:
			thread_list.get_children().front().grab_focus()
