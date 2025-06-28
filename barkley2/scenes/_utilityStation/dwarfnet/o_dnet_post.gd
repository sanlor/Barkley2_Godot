extends Control

const FORUM_POST 		:= preload("res://barkley2/scenes/_utilityStation/dwarfnet/forum_post.tscn")
const POST_ATTACH 		= preload("res://barkley2/scenes/_utilityStation/dwarfnet/post/post_attach.tscn")
const POST_POOL 		= preload("res://barkley2/scenes/_utilityStation/dwarfnet/post/post_pool.tscn")
const FORUM_DATA 		:= preload("res://barkley2/resources/B2_DNET/forum_data.json")
## About forum posts: Its bullshit.
# A forum post can have 3 or 7 arguments:
# Time 		- At what time this post was made?
# User 		- Which users posted that post.
# Post 		- the actuall message
# Quote 1 	- a quoote at the start of the messsage
# Post 2 	- A message after the initial quote
# Quote 2 	- A quote at the end of the message
# Warning 	- A warning that a MOD added.

const POST_BANNER = preload("res://barkley2/scenes/_utilityStation/dwarfnet/post/post_banner.tscn")

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
		
	## This is so stupid.
	if FORUM_DATA.data[thread_name].has("banner"):
		post_list.add_child( POST_BANNER.instantiate() )
		
	## This is so stupid x10.
	if FORUM_DATA.data[thread_name].has("Pool"):
		post_list.add_child( POST_POOL.instantiate() )
		
	## make posts
	var posts : Array = FORUM_DATA.data[thread_name].get("posts", [])
	for post : Array in posts:
		if post[0] == "image":
			## Fuck This...
			# Add support for forum attachments.. THAT ONLY HAPPEN IN ONE FORUM!
			## TODO
			#push_warning("Forum attachements not setup yet.")
			if B2_DNET.time_after( str( post[3] ) ):
				var att = POST_ATTACH.instantiate()
				## NOTE Fuck all this. lets ignore all additional info for now.
				att.attach_name = str( post[5] )
				post_list.add_child( att )
			#continue
		else:
			if B2_DNET.time_after( str( post[0] ) ):
				var p := FORUM_POST.instantiate()
				p.poster_time 	= str( post[0] )
				p.poster_name 	= str( post[1] )
				p.quote_1		= ""
				p.message_1		= str( post[2] )
				p.quote_2		= ""
				p.message_2		= ""
				p.warning		= ""
				
				## I LOVE WORKING ON STUPID GAMEMAKER CODE!!!
				if post.size() > 3:
					p.quote_1		= str( post[3] )
				if post.size() > 4:
					p.message_2		= str( post[4] )
				if post.size() > 5:
					p.quote_2		= str( post[5] )
				if post.size() > 6:
					p.warning		= str( post[6] )
					
				post_list.add_child( p )
	
	#scroll_container.get_v_scroll_bar().grab_focus()
