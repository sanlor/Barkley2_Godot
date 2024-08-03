extends TextureRect

## NOTE Code taken from oTitle > Draw

var logoXTimer := 0.0

func _process(delta):
	#draw_sprite(s_barkley2_logo, 0, SCREEN_WIDTH/2, logoX);
	logoXTimer += delta * 0.1
	## NOTE For some reason, sometimes I need to multiply or divide values by 2
	position.y = 40.0 + ( sin( logoXTimer * PI ) * 3 ) - (size.y / 2)
