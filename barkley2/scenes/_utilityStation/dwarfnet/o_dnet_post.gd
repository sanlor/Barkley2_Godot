extends Control

const FORUM_POST := preload("res://barkley2/scenes/_utilityStation/dwarfnet/forum_post.tscn")
const FORUM_DATA := preload("res://barkley2/resources/B2_DNET/forum_data.json")

@onready var post_list: VBoxContainer = $ScrollContainer/MarginContainer/post_list
@onready var scroll_container: ScrollContainer = $ScrollContainer

func post_dem_posts( thread_name : String ) -> void:
	if not FORUM_DATA.data.has( thread_name ):
		push_error("Invalid thread data")
		return
		
	## Cleanup
	for i in post_list.get_children():
		i.queue_free()
		
	## Scroll reset
	scroll_container.scroll_vertical = 0
		
	var posts : Array = FORUM_DATA.data[thread_name].get("posts", [])
	for post : Array in posts:
		if post.size() != 3:
			push_error("Weird post. check it out %s." % post)
			return
		var p := FORUM_POST.instantiate()
		p.poster_time 	= str( post[0] )
		p.poster_name 	= str( post[1] )
		p.message 		= str( post[2] )
		post_list.add_child( p )
