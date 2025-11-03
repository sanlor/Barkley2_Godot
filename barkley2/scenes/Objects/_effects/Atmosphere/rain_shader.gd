extends GPUParticles2D

const DEBUG := true

const SN_RAIN_HEAVY_01 				:= preload("uid://dp0rsrykfrpfi")
const SN_RAIN_HEAVY_INDOORS_01 		:= preload("uid://gbhdp6184m04")
const SN_RAIN_LIGHT_01 				:= preload("uid://cbcl8a5jo77i3")
const SN_RAIN_LIGHT_INDOORS_01 		:= preload("uid://dxdl568ti6o75")
const SN_RAIN_NORMAL_01 			:= preload("uid://cyqdmdcikgck7")
const SN_RAIN_NORMAL_INDOORS_01 	:= preload("uid://c4lr4q7k7qffx")

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if OS.has_feature("web"): ## Disable trail if web export, since its not supported.
		trail_enabled = false

func toggle_rain_shader( state : bool, rain_type : String, thunder : bool, interior : bool ): # toggled by the current room settings
	emitting = state and not interior 	## Only visible outside
	visible = state and not interior 	## Only visible outside
	
	if state:
		match rain_type:
			"light":		
				amount = 200; 
				if interior: 	_setup_audio(SN_RAIN_LIGHT_INDOORS_01); 
				else: 			_setup_audio(SN_RAIN_LIGHT_01)
			"normal":		
				amount = 400
				if interior: 	_setup_audio(SN_RAIN_NORMAL_INDOORS_01); 
				else: 			_setup_audio(SN_RAIN_NORMAL_01)
			"heavy":		
				amount = 800
				if interior: 	_setup_audio(SN_RAIN_HEAVY_INDOORS_01); 
				else: 			_setup_audio(SN_RAIN_HEAVY_01)
			_:				
				amount = 200
				if interior: 	_setup_audio(SN_RAIN_NORMAL_INDOORS_01); 
				else: 			_setup_audio(SN_RAIN_NORMAL_01)
				
		if thunder: push_error("Thunder not implemented yet.")
	
	if DEBUG: print_rich("[color=pink]%s: Shader '%s' is %s." % [name,"rain_shader",state] )

func _setup_audio( audio_stream : AudioStream ) -> void:
	audio_stream_player.stream = audio_stream
	audio_stream_player.play()

func _process(_delta: float) -> void:
	if is_node_ready():
		if visible:
			if B2_CManager.camera: ## FIXME 
				position = B2_CManager.camera.position - Vector2(384.0,240.0) / 2.0
				#position += B2_CManager.camera.offsets
	
