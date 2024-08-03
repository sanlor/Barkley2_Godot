extends ColorRect

## 6 HOURS!

@onready var togtech_cranial = $"."
@onready var togtech_anim = $togtech_anim
@onready var togtech_text = $togtech_text

enum MODE{CRANIAL,DATA}
var curr_mode := MODE.CRANIAL

var cranial_texts := [
	Text.pr( "ToGTech Cranial Neurodeck service initializing..." ),
	Text.pr( "It is now safe to connect your cranial USB to#the computer. Detecting cranial USB..." ),
	Text.pr( "Detecting cranial USB..." ),
	Text.pr( "No ToGTech Cranial Neurodeck connection detected.#Defaulting to DNA palm scanner service..." ),
]
var curr_cranial_texts := 0

var data_texts := [
	Text.pr( "DNA successfully scanned. Uploading DNA#to Tales of Game's Corp. Corp. database..." ),
	Text.pr( "Uploading DNA to#Zyriex Pharmaceuticals database... " ),
	Text.pr( "Uploading DNA to#INTERPOL criminal database..." ),
	Text.pr( "Synchronizing DNA to#Shumaker-Raum Dynamic Marketing System..." ),
	Text.pr( "Synchronizing DNA to#Coulombe Strategic Marketing..." ),
	Text.pr( "Data synchronized." ),
]
var curr_data_texts := 0

func _ready():
	togtech_anim.play("default")

func set_mode( b : bool ):
	if b:
		curr_mode = MODE.CRANIAL
	else:
		curr_mode = MODE.DATA

func set_text_pos():
	togtech_anim.global_position = Vector2(192, 154)
	
	if curr_mode == MODE.CRANIAL:
		togtech_text.global_position = Vector2(0, 124)
		togtech_text.text = cranial_texts[ curr_cranial_texts ]
	elif  curr_mode == MODE.DATA:
		togtech_text.global_position = Vector2(0, 114)
		togtech_text.text = data_texts[ curr_data_texts ]

func next_text():
	if curr_mode == MODE.CRANIAL:
		curr_cranial_texts += 1
		if curr_cranial_texts >= 4:
			## end
			return
			
		if curr_cranial_texts == 0 or curr_cranial_texts == 2:
			togtech_text.global_position = Vector2(0, 124)
		else:
			togtech_text.global_position = Vector2(0, 114)
		togtech_text.text = cranial_texts[ curr_cranial_texts ]
	elif  curr_mode == MODE.DATA:
		curr_data_texts += 1
		if curr_data_texts >= 6:
			## end
			return
			
		if curr_data_texts == 5:
			togtech_text.global_position = Vector2(0, 124)
		else:
			togtech_text.global_position = Vector2(0, 114)
		togtech_text.text = data_texts[ curr_data_texts ]
