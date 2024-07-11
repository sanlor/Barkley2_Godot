@tool
extends Control

@onready var cc_name_box = $cc_name_box
@onready var cc_name_prompt = $cc_name_prompt


var letters := "ABCDEFGHIJKLMNOPQRSTUVWXYZ-_1234567890:;$ "
var display_letters_in_uppercase := false

func _ready():
	cc_name_box.global_position = Vector2( 192, 99 ) - (cc_name_box.size / 2)
	cc_name_prompt.global_position = Vector2(101, 48 - 10)
	#for (i=0; i<14; i+=1;)
	#{
	#draw_text(97 + i * 14, 39, name_letter[i])
	#}
	
	for r in 3:
		for i in 14:
			var offset := 14
			var row_height := 20 * r
			
			var letter_btn := Button.new()
			cc_name_box.add_child( letter_btn )
			letter_btn.text = letters[ i + (offset * r)]
			letter_btn.size = Vector2( 14, 22 )
			letter_btn.global_position = Vector2( 97 + i * offset, 70 + row_height)
			#label1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
