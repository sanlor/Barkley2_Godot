extends TextureRect

## NOTE none yet

#//Demo Graphic and Text if Needed
#if global.demoBlocker == 1 && global.DEBUGMODE == 0 {
	#scr_font(global.fn_small, c_yellow, 0, 0);
	#draw_sprite(s_jankyDemo01, 0, SCREEN_WIDTH/1.5, SCREEN_HEIGHT/2 - 20);
	#draw_text(qrx, qry, "DEMO game for backers.");
	#qry += 14; 
	#draw_text(qrx, qry, "Substantial levels of WONK and JANK.");
	#qry += 14; 
	#draw_text(qrx, qry, "Experience accordingly.");
	#
	#// Font //
	#draw_set_font(global.fn_2c);
	#draw_set_alpha(1);

func _ready():
	pass
	#position.x = get_viewport_rect().end.x / 2.3
	#position.y = get_viewport_rect().end.y / 2 - 40

