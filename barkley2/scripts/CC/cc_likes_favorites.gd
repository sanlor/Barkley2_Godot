extends Control

signal likes_n_favorites_selected

@onready var banner = $banner
@onready var choose_your_x = $banner/choose_your_x
@onready var like_fav_frame = $LikeFav_frame

func _ready():
	hide()
	banner.hide()
	like_fav_frame.hide()
	
func show_likes():
	show()
	modulate.a = 0.0
	banner.show()
	banner.modulate.a = 0.0
	like_fav_frame.show()
	like_fav_frame.modulate.a = 0.0
	choose_your_x.text = Text.pr( "Chose Your Likes" )
	var tween := create_tween()
	tween.tween_property( self, "modulate:a", 1.0, 0.25 ) # show BG
	tween.tween_property( banner, "modulate:a", 1.0, 0.75 )
	tween.tween_interval( 2.5 )
	tween.tween_property( banner, "modulate:a", 0.0, 0.75 )
	tween.tween_property( like_fav_frame, "modulate:a", 1.0, 0.75 )
	await tween.finished
	
	await like_fav_frame.pressed_accept
	choose_your_x.text = Text.pr( "Choose your favorites" )
	
	tween = create_tween()
	tween.tween_property( like_fav_frame, "modulate:a", 0.0, 0.75 )
	tween.tween_callback( like_fav_frame.toggle_mode ) 
	tween.tween_property( banner, "modulate:a", 1.0, 0.75 )
	tween.tween_interval( 2.5 )
	tween.tween_property( banner, "modulate:a", 0.0, 0.75 )
	tween.tween_property( like_fav_frame, "modulate:a", 1.0, 0.75 )
	await tween.finished
	
	await like_fav_frame.pressed_accept
	
	B2_Playerdata.character_dropdown_likes = like_fav_frame.selection_like;
	B2_Playerdata.character_dropdown_favorites = like_fav_frame.selection_favorite
	
	B2_Playerdata.Quest("playerCCLikes", var_to_str(like_fav_frame.selection_like) );
	B2_Playerdata.Quest("playerCCFaves", var_to_str(like_fav_frame.selection_favorite) );
	
	tween = create_tween()
	tween.tween_property( self, "modulate:a", 0.0, 0.25 ) # show BG
	tween.tween_callback( emit_signal.bind("likes_n_favorites_selected") )
