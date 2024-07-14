#@tool
extends Control

## Holy shit, someone spent a lot of time on this part.
# too much text and weird calculations.
# this object mentions a hand scanner. not sure yet where that goes.

signal input_finished(death)

@onready var animation_player = $AnimationPlayer

# Alignment grid
@onready var alignment_grid = $alignment_grid

@onready var grid_piece_highlight = $alignment_grid/piece_highlight
@onready var grid_piece = $alignment_grid/piece

@onready var click_label = $alignment_grid/click_label

# Quiz paper
@onready var alignment_questions = $alignment_questions

@onready var statement_title = $alignment_questions/statement_title
@onready var statement_content = $alignment_questions/statement_content
@onready var awnser_title = $alignment_questions/awnser_title

@onready var strongly_agree_btn = $alignment_questions/strongly_agree_btn
@onready var agree_btn = $alignment_questions/agree_btn
@onready var neutral_btn = $alignment_questions/neutral_btn
@onready var disagree_btn = $alignment_questions/disagree_btn
@onready var strongly_disagree_btn = $alignment_questions/strongly_disagree_btn

@onready var alignment_buttons := [strongly_agree_btn, agree_btn, neutral_btn, disagree_btn, strongly_disagree_btn]
@onready var alignment_buttons_name := ["Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree"]

var question_text : Array[String]
var answer_x : Array[ Array ]
var answer_y : Array[ Array ]
var question_id := 0
var amount_of_question := 5 # Nº of questions to be asked ## DEFUALT IS 5

# Align piece movement
var piece_grid_origin := Vector2(33,49) # the grid start at 33x44
var piece_grid_size := Vector2(32,16) # each cell is 32x16
var alignment_grid_size := Vector2(10,10) # The whole grid is 10x10

var piece_can_move := false
var piece_finished_moving := false

var target_x := 0.0
var target_y := 0.0
var total_moved := Vector2.ZERO

var weird_offset := Vector2( 0, -4.5 ) 

var chess_piece_audio : AudioStreamPlayer

func _ready():
	modulate.a = 0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	
	## Questions and awnsers effects
#region Too many questions, wtf!
	question_text.resize(32)
	question_text[0] = "The Tales of Game's brand plays an important part of my every day life."
	question_text[1] = "It's hypocritical that they can call each other halflings but we have to call them hobbits."
	question_text[2] = "I believe strongly in the healing power of medicine."
	question_text[3] = "I have never jacked off to a UFO."
	question_text[4] = "Subs not dubs."
	question_text[5] = "Cops just wanna have fun!"
	question_text[6] = "Jocks are the cornerstone of our society."
	question_text[7] = "Homework is for the ignorant."
	question_text[8] = "Teachers are bullshit."
	question_text[9] = "The instrument I most identify with is the bugle."
	question_text[10] = "There is a lot of untapped power in jocks."
	question_text[11] = "It is never okay to use the words 'meh' or 'feh'."
	question_text[12] = "I think repeating internet memes out loud in real life is really cool"
	question_text[13] = "My goal is to amass more trophies than anyone else."
	question_text[14] = "I'm willing to forgo my sense of right and wrong for candy and toys."
	question_text[15] = "I am descended from an ancient jock."
	question_text[16] = "Dare not disturb me while I play vidcons, mom."
	question_text[17] = "Touch my sport whistle at your own peril."
	question_text[18] = "The government doesn't have the right to tell gamers what to play."
	question_text[19] = "I support pan-dwarfism."
	question_text[20] = "Refs can't tell me what to do."
	question_text[21] = "I spend more time in cyberspace than meatspace."
	question_text[22] = "Jock jams soothe the aching soul."
	question_text[23] = "Murder is getting out of hand these days. It should be against the law."
	question_text[24] = "There is no law in cyberspace."
	question_text[25] = "I would never touch a ghost in an inappropriate place."
	question_text[26] = "Bring on the juggling clowns!"
	question_text[27] = "Don't cuss near parents and teachers."
	question_text[28] = "Get a life..."
	question_text[29] = "Something about bigotry rubs me the wrong way."
	question_text[30] = "Bw...bwahahaha..."
	question_text[31] = "I am the ultimate life form."
	
	## I cant believe someone did this like this. thar aheve to be a better way...
	# Effects of answers #
	answer_x.resize(32)
	answer_y.resize(32)
	
	# had to manual convert all of these by hand. hell is very real, and im living in it.
	answer_x[0] = [-1,-3,+0,+2,+2,]
	answer_y[0] = [-3, +0, +1, +0, +1,]

	answer_x[1] = [+3, -2, +0, +0, -2,]

	answer_y[1] = [-2, +0, +3, -1, -2,]

	answer_x[2] = [-1, -4,+1, +2, +0,]

	answer_y[2] = [-4, +2, +1, +0, +0,]

	answer_x[3] = [+2, +0, +0, +0, -2,]

	answer_y[3] = [+0, +0, +3, -1, -3,]

	answer_x[4] = [+0, +0, +2, -3, +0,]

	answer_y[4] = [+0, +3, +0, +2, -3,]

	answer_x[5] = [+1, +2, +0, +0, -3,]

	answer_y[5] = [-3, +0, -4, +0, -2,]

	answer_x[6] = [-1, +0, +0, -2, +1,]

	answer_y[6] = [+0, +2, +2, -3, +0,]

	answer_x[7] = [-1, -2, -1, +3, +2,]

	answer_y[7] = [+1, -4, +3, +0, +2,]

	answer_x[8] = [+0, +2, +3, +1, +0,]
	
	answer_y[8] = [+0, +0, +1, -3,-1,]

	answer_x[9] = [-3, +0, -2, +1, +0,]

	answer_y[9] = [+2, -1, +3, +0, +0,]

	answer_x[10] = [-4, +0, +2, +4, -1,]

	answer_y[10] = [-3, -1, +0, +1,+2,]

	answer_x[11] = [+2, +0, +0, -6, -2,]

	answer_y[11] = [-3,-1, +0, +2, +3,]

	answer_x[12] = [-2, -1,+0, +1, +1,]

	answer_y[12] = [+2, +0, +3, -2, -1,]

	answer_x[13] = [-2, -1, +0, +3, +1,]

	answer_y[13] = [+3,+0, +3, -3, -2,]

	answer_x[14] = [+0,+0, +2, +1, +1,]

	answer_y[14] = [-2, +1,-2, +0, +3,]

	answer_x[15] = [+4, -2, +0, +0, -2,]

	answer_y[15] = [-3, +0, +2, +0, -4,]

	answer_x[16] = [+0, +0, +0, -1, +4,]

	answer_y[16] = [+0, +2, -2, +3, +1,]

	answer_x[17] = [+2, -1, +0, +0, -3,]

	answer_y[17] = [+0, +0, +3, +1, +1,]

	answer_x[18] = [+0, +0, +0, +2, -3,]

	answer_y[18] = [+0,-2, +3, +2,+1,]

	answer_x[19] = [+2, +0, -1, -2, +0,]

	answer_y[19] = [+0, +0, -2, +0, +1,]

	answer_x[20] = [+0, -1, -2, +3, +1,]

	answer_y[20] = [-1,-2,+1, +2, +0,]

	answer_x[21] = [-1, -3, +0, +2, +2,]

	answer_y[21] = [-2, +0, -3, +0, +2,]

	answer_x[22] = [-2, +0, +0, +3,+1,]

	answer_y[22] = [+4, +0, +3, +0, +1,]
# AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	answer_x[23] = [+0, +0, +0, +2, +1,]

	answer_y[23] = [+0, -2, +1, +0, -1,]

	answer_x[24] = [+0, +3, +0, -3, -2,]

	answer_y[24] = [+3, -2, -2, +2, -1,]

	answer_x[25] = [+0, +1, +0, -3, -1,]

	answer_y[25] = [-1, -2, +0, +2, -1,]

	answer_x[26] = [-1, -3, +0, +4, +2,]

	answer_y[26] = [-1, +0, -2, +0, +2,]

	answer_x[27] = [+0, +0, +0, -3, +4,]

	answer_y[27] = [+0,+2, -1, +3, +2,]

	answer_x[28] = [+0, +0, +0, +2, -3,]

	answer_y[28] = [+0, -1, +2, +3, +1,]

	answer_x[29] = [-7, +0, +1, +2, -1,]

	answer_y[29] = [-1, -2, +0, +3, +2,]

	answer_x[30] = [+2, +0, +0, +0, -1,]

	answer_y[30] = [+0, +0, +1, -3, -1,]

	answer_x[31] = [+2, -1, +0, +0, -2,]

	answer_y[31] = [-3, +0, +3, -1, -2,]
	
#endregion
	
	alignment_grid.set_deferred( "size", Vector2(384,240) )
	alignment_questions.set_deferred( "size", Vector2(384,240) )
	
	statement_title.position = Vector2(67, 36)
	statement_title.text = Text.pr( "Statement:" )
	statement_title.modulate = Color.RED
	
	statement_content.position = Vector2(67, 52) + Vector2(0, 1) ## The original was 1 pixel off;
	statement_content.text = Text.pr( "PLACEHOLDER TEXT" )
	statement_content.size = Vector2(270, 0) # Had to mess around on the label to make this work ok.
	
	awnser_title.position = Vector2(67, 117)
	awnser_title.text = Text.pr( "Answer:" )
	awnser_title.modulate = Color.RED
	
	for i in 5:
		alignment_buttons[i].text = Text.pr ( alignment_buttons_name[i] )
		alignment_buttons[i].position = Vector2(67, 133 + i * 16)
		alignment_buttons[i].size = Vector2(256,8)
		alignment_buttons[i].pressed.connect( func(): awnser_question(i) )
	
	#grid_piece.position = Vector2( 48 + 4.5 * 32, 44 + 4.5 * 16 )
	grid_piece.position = Vector2( 48 + 4.5 * 32, 44 + 4.5 * 16 ) + weird_offset
	question_id = randi_range(0,31) # Initial random
	ask_question()
	
func ask_question():
	for btn in alignment_buttons:
		btn.disabled = false
	question_id += 1 + randi_range(0,2) # this avoid asking repeated questions. pretty clever, huh?
	question_id = wrapi(question_id, 0, 31) # Lets avoid an array overflow, ok?
	#question_id = 12  ## DEBUG
	statement_content.text = Text.pr( question_text[question_id] )
	

func awnser_question( choice : int):
	if question_id == 12 and choice == 0:
		## TODO kill the player with cc_death
		B2_Sound.play("sn_cc_death")
		B2_Music.play("mus_gameover", 0.1)
		input_finished.emit(true)
		return
		
	for btn in alignment_buttons: # avoid user awnsering twice while the screen is scrolling
		btn.disabled = true
		
	B2_Sound.play("sn_cc_generic_button1")
	total_moved.x += answer_x[question_id][choice] # keep trach of the total chess piece movement
	total_moved.y += answer_y[question_id][choice] # keep trach of the total chess piece movement
	target_x = round( grid_piece.position.x ) + ( answer_x[question_id][choice] * piece_grid_size.x ) # + 16
	target_y = round(grid_piece.position.y) + ( answer_y[question_id][choice] * piece_grid_size.y ) # + 8
	
	target_x = clamp(target_x, 33, 320 )
	target_y = clamp(target_y, 49, 192 )
	
	move_to_grid()

func move_to_grid():
	animation_player.play("move_to_grid")
	await animation_player.animation_finished
	piece_can_move = true
	chess_piece_audio = B2_Sound.play("sn_cc_chesspiece", false, 10)
	ask_question()
	
func move_to_quiz():
	animation_player.play("move_to_quiz")
	await animation_player.animation_finished

func _process(delta):
	if piece_finished_moving:
		if Input.is_action_just_pressed("Action"):
			piece_finished_moving = false
			click_label.hide()
			amount_of_question -= 1
			if amount_of_question >= 0:
				move_to_quiz()
			else:
				get_alignment()
			
	if piece_can_move:
		
		grid_piece.position.y = move_toward(grid_piece.position.y, target_y, 30.0 * delta)
		grid_piece.position.x = move_toward(grid_piece.position.x, target_x, 30.0 * delta)
		
		if grid_piece.position.x == round(target_x):
			grid_piece.position.x = target_x
			#print("x")
			if grid_piece.position.y == round(target_y):
				grid_piece.position.y = target_y
				#print("y")
				piece_can_move = false
				piece_finished_moving = true
				B2_Sound.stop(chess_piece_audio)
				chess_piece_audio = null
				click_label.show()
				
func get_alignment():
	var ethical 	:= 0
	var alignment 	:= 0
	var moral 		:= 0
	## Damn, what a mess.
	if total_moved.x >= 0 and total_moved.x <= 2:
		ethical = 0;
		if total_moved.y >= 0 and total_moved.y <= 2:
			alignment = 0
			moral = 0
		elif total_moved.y >= 3 and total_moved.y <= 6:
			alignment = 1
			moral = 1
		elif total_moved.y >= 7 and total_moved.y <= 9:
			alignment = 2
			moral = 2
	elif total_moved.x >= 3 and total_moved.x <= 6:
		ethical = 1;
		if total_moved.y >= 0 and total_moved.y <= 2: 
			alignment = 3
			moral = 0
		elif total_moved.y >= 3 and total_moved.y <= 6:
			alignment = 4
			moral = 1
		elif total_moved.y >= 7 and total_moved.y <= 9:
			alignment = 5
			moral = 2
	elif total_moved.x >= 7 and total_moved.x <= 9:
		ethical = 2;
		if total_moved.y >= 0 and total_moved.y <= 2:
			alignment = 6
			moral = 0
		elif total_moved.y >= 3 and total_moved.y <= 6:
			alignment = 7
			moral = 1
		elif total_moved.y >= 7 and total_moved.y <= 9:
			alignment = 8
			moral = 2
			
	B2_Playerdata.character_alignment_x = round( ( grid_piece.position.x - piece_grid_origin.x ) / piece_grid_size.x)
	B2_Playerdata.character_alignment_y = round( ( grid_piece.position.y - piece_grid_origin.y ) / piece_grid_size.y)
	B2_Playerdata.character_alignment 	= alignment
	B2_Playerdata.character_moral 		= moral
	B2_Playerdata.character_ethical 	= ethical
	
	animation_player.play("end_animation")
	await animation_player.animation_finished
	
	input_finished.emit(false)
	queue_free()
	
