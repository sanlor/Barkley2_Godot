extends Control

@onready var option_1 = $option1
@onready var option_2 = $option2

signal awnsered_question( bool )

func setup_questions( _option1 : String, _option2 : String ):
	
	option_1.pressed.connect( func(): awnsered_question.emit(true); hide() )
	option_2.pressed.connect( func(): awnsered_question.emit(false); hide() )
	
	option_1.text = _option1
	option_2.text = _option2
	
	show()
	
