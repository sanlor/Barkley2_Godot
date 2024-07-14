extends Control

## CHaracter creation. Lots of objects are involved in this.

# o_cc_data holds some important data
# o_cc_effect_crystal - Some kind of effect, not sure
# o_cc_effect_backdrop - Some kind of effect, particules, aparently
# 
# Events are in this order:
# o_cc_wizard - wizar apears, moves hands and talk: - DONE
# o_cc_name - Player adds its name and handles text displaying
## FOCUS ON THESE ONES ^^^^^^^^

# cc_death seems imporant

@export_category("DEBUG")
@export var skip_hands := false
@export var skip_name := false
@export var skip_zodiac_pre_dialog := false
@export var skip_zodiac_input := false
@export var skip_zodiac_pos_dialog := false
@export var skip_blood := false
@export var skip_gender := false
@export var skip_alignment := false
@export var skip_alignment_questions := false


@onready var animation_player = $AnimationPlayer

@onready var fade_texture = $fade_texture

@onready var cc_wizard_base = $cc_wizard_base
@onready var cc_wizard_emote = $cc_wizard_emote
@onready var cc_wizard_talk = $cc_wizard_talk

@onready var cc_textbox = $cc_textbox

# all stages are preloaded and instantiated. they are added to the scene wehn needed
@onready var cc_name 		= preload("res://barkley2/scenes/CC/cc_name.tscn").instantiate()
@onready var cc_zodiac 		= preload("res://barkley2/scenes/CC/cc_zodiac.tscn").instantiate()
@onready var cc_blood 		= preload("res://barkley2/scenes/CC/cc_blood.tscn").instantiate()
@onready var cc_gender 		= preload("res://barkley2/scenes/CC/cc_gender.tscn").instantiate()
@onready var cc_alignment	= preload("res://barkley2/scenes/CC/cc_alignment.tscn").instantiate()
@onready var cc_death		= preload("res://barkley2/scenes/CC/cc_death.tscn")

## Timers //
var timer_alpha_in 			= 10.0 / 10
var timer_prepare_hands 	= 25.0
var timer_show_hands 		= 0.0;
var timer_sound 			= 25.0
var timer_ready_to_proceed 	= 35.0

var image_index_intro = 0.0;

func play_sfx(track_name : String):
	#B2_Sound.play("sn_cc_wizard_arms")
	B2_Sound.play(track_name)

func _ready():
	fade_texture.show()
	#await get_tree().create_timer(8.0).timeout
	
	B2_Music.play			( "mus_charcreate" )
	animation_player.play	( "wizard_intro" )
	#var tween := create_tween()
	#tween.tween_property(fade_texture, "modulate:a", 0.0, timer_alpha_in )
	#B2_Sound.play("sn_cc_wizard_arms")
	
func wizard_is_talking():
	cc_wizard_talk.show()
	var new_frame := wrapi(cc_wizard_talk.frame, 0, 3)
	new_frame += randi_range(0,1) + 1
	cc_wizard_talk.frame = new_frame
	
func wizard_is_silent():
	cc_wizard_talk.hide()
	pass
	
func wizard_is_emoting():
	cc_wizard_emote.show()
	cc_wizard_emote.frame = randi_range(0,2)
	await get_tree().create_timer(2).timeout
	cc_wizard_emote.hide()
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "wizard_intro":
		#animation_player.stop( )
		cc_process()
		
func cc_process():
	if not skip_hands: # Wizard waves its hands and talks a lot.
		cc_textbox.display_text( Text.pr( "Greetings, young one. I have been awaiting your#arrival for some time now. The world has been#waiting for your arrival. Ah, but my manners...#Please, take a seat and make yourself comfortable.") )
		await cc_textbox.finished_typing
		
		cc_textbox.display_text( Text.pr( "Tell me about yourself... Yes, your name... What is#your name?") )
		await cc_textbox.finished_typing
		
		cc_textbox.texbox_hide()
		await cc_textbox.visibility_changed
	
	if not skip_name: # name prompt apears, waiting for you to type yourt name.
		add_child( cc_name )
		await cc_name.name_entered
	
	if not skip_zodiac_pre_dialog:
		cc_textbox.display_text( Text.pr( "It is by light that the troglodyte emerged from the#cave to become man and it is by light that man#navigates the cosmos to become more." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "The stars, the heavens, tiny specks of flame that#illuminate the night, have guided human thought#and imagination since the dawn of our race." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "We find our way, draw our energy, build our#civilizations through their luminescence. And we#find ourselves through them." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "It is the incandescent mind of man that imprinted#its legends in the stars - the Zodiacs. Tell me your#birthday, so I may tell you your star..." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
	if not skip_zodiac_input:
		# Show a black screen, add cc_zodiac
		var z_tween : Tween
		
		z_tween = create_tween()
		fade_texture.show()
		fade_texture.color.a = 0.0
		z_tween.tween_property(fade_texture, "color:a", 1.0, timer_alpha_in )
		await z_tween.finished
		
		add_child(cc_zodiac)
		
		z_tween = create_tween()
		z_tween.tween_property(fade_texture, "color:a", 0.0, timer_alpha_in )
		await z_tween.finished
		fade_texture.hide()
		
		# wait for the player to set the cc_zodiac
		await cc_zodiac.zodiac_entered
		
		# Show a black screen, remove cc_zodiac
		fade_texture.show()
		fade_texture.color.a = 0.0
		z_tween = create_tween()
		z_tween.tween_property(fade_texture, "color:a", 1.0, timer_alpha_in )
		await z_tween.finished
		
		remove_child(cc_zodiac)
		
		z_tween = create_tween()
		z_tween.tween_property(fade_texture, "color:a", 0.0, timer_alpha_in )
		await z_tween.finished
		fade_texture.hide()
		
	if not skip_zodiac_pos_dialog:
		# holy shit, I hate this! vvvvvv
		assert( B2_Playerdata.character_zodiac in range(1,12) )
		match B2_Playerdata.character_zodiac: # Should be 1 to 12
			1:
				cc_textbox.display_text( Text.pr( "Ahh, the brash Aries, boastful to a fault, quick to#anger... but steadfastly loyal, you put your#companions before yourself." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Your friends will be few and far between, but they#will be true indeed." ) )
				await cc_textbox.finished_typing
			2:
				cc_textbox.display_text( Text.pr( "Ahh, the most courageous of all the star signs -#Taurus, the seeker. A warrior unparalleled, your#foes will bow to your might and majesty." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "But, you must be cautious to temper your power#with justice..." ) )
				await cc_textbox.finished_typing
			3:
				cc_textbox.display_text( Text.pr( "Ahhh, a Gemini, a true scholar. Your wisdom and#insight inspire those around you. Your curious#nature can sometimes lead you and those closest to#you in trouble." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "But perhaps that is not the weakness it seems..." ) )
				await cc_textbox.finished_typing
			4:
				cc_textbox.display_text( Text.pr( "A Cancer, I see? Yes, I could tell by your movement,#fluid, graceful, confident, that you possessed the#gift of Cancer. You must make haste in the trials#that await you..." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Perhaps it is speed that your journey most#requires..." ) )
				await cc_textbox.finished_typing
			5:
				cc_textbox.display_text( Text.pr( "A Leo! Ahh, I could sense it in your eyes, your#empathy, your warmth towards others. Your#kindness is your strength and your heart is open#to all..." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "But, you must be wary not to let in those who would#do you harm..." ) )
				await cc_textbox.finished_typing
			6:
				cc_textbox.display_text( Text.pr( "It is an honor to stand before a warrior of the#Virgo star sign! Chivalrous and valiant, your heart#burns with a sincerity unknown in our modern#times." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "But soon... you may be forced to choose between#your idealism and reality..." ) )
				await cc_textbox.finished_typing
			7:
				cc_textbox.display_text( Text.pr( "Ah, the stern and aloof Libra. Behind your mask of#stoicism is a passion that you guard deeply. You#know the power of emotion. You choose to reveal#yours only when the time is right." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Perhaps the journey that awaits you is one where#passions run deep and the wellspring of emotions#you've been holding back must flow..." ) )
				await cc_textbox.finished_typing
			8:
				cc_textbox.display_text( Text.pr( "Scorpio, the curious wanderer... Your keen intellect#is fueled by a passion for discovery; your zest#for life is what propels you." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Your inquisitiveness can get you into trouble, but#it is also your greatest asset." ) )
				await cc_textbox.finished_typing
			9:
				cc_textbox.display_text( Text.pr( "You are an Ophiucus! This... this is a surprise,#indeed. The stars tell much of the enigmatic Zodiac#Ophiucus, and yet they say so little." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Whispers, screams, echoes upon walls of echoes.#This galaxy, this playpen for the whims of F.A.T.E. - #its meaning can only be deduced so much." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Perhaps the power of this Zodiac has yet to be#revealed. And perhaps... it will be revealed through#you." ) )
				await cc_textbox.finished_typing
			10:
				cc_textbox.display_text( Text.pr( "Sagittarius the Beautiful. It is said that those#bearing the star sign of Sagittarius possess the#social graces and charisma of their namesake#Zodiac, but also the duplicity." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Learn ye this: The words we speak, we must keep#and this is doubly so for the loquacious Sagittarius." ) )
				await cc_textbox.finished_typing
			11:
				cc_textbox.display_text( Text.pr( "Ah... you are a Capricorn..." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "Well, no matter. I am sure Capricorn's legendary#shortcomings do not reflect on you. After all, how#can we deduce meaning from arbitrary points of#light billions upon billions of miles away?" ) )
				await cc_textbox.finished_typing
			12:
				cc_textbox.display_text( Text.pr( "Aquarius the Hunter! Aquarius' keen eye made her#the greatest bowman in the cosmos; her steady arm#brought down many a beast." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "But it was with her sharp senses that she#discovered the infidelity of her love, rending her#heart in twain." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "There are those that say ignorance is bliss, and#many an Aquarius is among them." ) )
				await cc_textbox.finished_typing
			13: ##???????
				cc_textbox.display_text( Text.pr( "You were born under the sign of Pisces, the#Quixotic! Your heart is free, your spirit unattached#to the mores and anchors of society. You live life#for yourself, just as Pisces did." ) )
				await cc_textbox.finished_typing
				
				cc_textbox.display_text( Text.pr( "But you do not walk the path ahead of you alone.#Can you learn to fight for those beside you? Can the#shield fight without the sword?" ) )
				await cc_textbox.finished_typing
				
		var china = floor( B2_Playerdata.character_zodiac_year % 10 ) ## china = floor(year mod 10);
		match china: 
			0:
				cc_textbox.display_text( Text.pr( "I also see swirling gasses, bodies streaming through#thick cosmic fog, the invisible fingers of gravity#hurtling comets and planets and all manner of#debris into the infinite potpourri of space." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "The untamed creative energies in your mind churn#in perpetual parallel to the chaos of the universe." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You have a deep, powerful connection to the#Whirlpool Galaxy - a galaxy of infinite chaos... and#infinite potential." ) )
				await cc_textbox.finished_typing
			1:
				cc_textbox.display_text( Text.pr( "There is also a deep sense of dignity and grace#within you. Others view you with a sense of#eminence, even majesty." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You have always been different, perhaps elevated,#from the people around you. You are not an#outcast - no, you live by your own code, a code#of austerity and self-determination." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You are the noble Moon that guides us in the night." ) )
				await cc_textbox.finished_typing
			2:
				cc_textbox.display_text( Text.pr( "But there is more... there is a hunger inside of you,#an untamed voracity for all that there is to take,#be it life or pleasure or some earthly commodity."  ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "But it is neither emptiness nor gluttony that #compels you - it is your base, unchangeable nature,#just as it is the nature of Black Holes to consume#all in their wake." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You will continue to devour all before you until#you gutter out, leaving no trace of your existence#- only swathes of emptiness in the places you have#been." ) )
				await cc_textbox.finished_typing
			3:
				cc_textbox.display_text( Text.pr( "I also see a stirring deep within you, a dormant#violence with a force far beyond your own#reckoning." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Beneath your calm surface lies a raging core, a#bellicose ember waiting to be stoked by the winds#of destruction." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Like countless Asteroids and Comets, you glide#serenely through the cosmos, but F.A.T.E. dictates#that eventually... you must collide." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "The annihilation you unleash when this happens#will change you... and the galaxy... forever." ) )
				await cc_textbox.finished_typing
			4:
				cc_textbox.display_text( Text.pr( "I also sense an innate calmness within you, a#mildness and compassion for others. Your actions#are guided by your empathy and you share a deep#bond with the life giving Red Dwarf;" ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Your presence nurtures the people around you and#your gentle temperament, though subdued, is a#magnet for those in need." ) )
				await cc_textbox.finished_typing
			5:
				cc_textbox.display_text( Text.pr( "There is also an incredible sense of mystery about#you, an enigmatic aura that obfuscates your true#nature. You are quiet but not idle, the Rube#Goldberg machine in your head in constant motion." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Scientists, oracles, philosophers, psychologists -#from all angles they prod, but none can unravel#this Gordian Knot." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Like the Jovian planet Jupiter, the more we learn,#the more we know we have yet to learn." ) )
				await cc_textbox.finished_typing
			6:
				cc_textbox.display_text( Text.pr( "The ancient Zoroastrians were the greatest#astronomers and cosmologists of antiquity." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Their skill in stargazing was unparalleled by any#other civilization for centuries, perhaps millennia,#to come." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Through their cosmic exploration, they came to#appreciate the life-giving and nurturing power#of the Sun, as well as humanity's dependence on it#and indeed, came to worship its flames." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You bear a deep connection with the Sun, just as#the ancient Zoroastrians did. And perhaps...#you are their greatest legacy..." ) )
				await cc_textbox.finished_typing
			7:
				cc_textbox.display_text( Text.pr( "But wait... I also see massive rocks - asteroids -#hurtling through the void. Individually, these#rocks crash and collide, slamming into one another,#a cacophonous symphony of perpetual carnage." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "But they also form a unified entity, an Asteroid#Belt drifting in a perfect ellipse around the#sun. It is an ordered chaos." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Each asteroid is an atom in the grand molecule of#the Asteroid Belt - the law needs chaos to exist#and vice versa. The duality of the Asteroid Belt#is something I see deep within you." ) )
				await cc_textbox.finished_typing
			8:
				cc_textbox.display_text( Text.pr( "In 1731, John Bevis made a discovery that would#change the course of human history, a discovery#that is often referred to as Bevis' Gambit." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Through his primitive telescope, Bevis saw a cloud#of prismatic gasses, forever shifting in color and#shape in psychedelic metamorphosis." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Bevis had discovered the Crab Nebula, a cosmic#body that has come to represent the wonder of the#universe and the possibilities of what remains#undiscovered." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "I see in you both a deep connection to the Crab#Nebula... and to Bevis." ) )
				await cc_textbox.finished_typing
			9:
				cc_textbox.display_text( Text.pr( "Know thou that every fixed star hath its own#planets, and every planet its own creatures,#whose numbers no man can compute." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "I also see in you a wild energy, a bond that ties#you to every living thing in the cosmos no matter#its origin or form." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "The empathic kinship with all Life within you is#perhaps the most powerful force that can exist,#more than 1,000 atomic bombs, and for this reason#it is your greatest strength" ) )
				await cc_textbox.finished_typing
				
	if not skip_blood:
		cc_textbox.display_text( Text.pr( "And what blood runs through your veins?" ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
		await get_tree().create_timer(1.0).timeout
		add_child( cc_blood )
		await cc_blood.accept_pressed
		remove_child( cc_blood )
		await get_tree().create_timer(1.0).timeout
		
		cc_textbox.display_text( Text.pr( "Yes, yes... the blood of warriors, the blood of kings.#Your heritage is one of greatness and it confers in#you much strength. Perhaps enough to save us all..." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
	if not skip_gender:
		cc_textbox.display_text( Text.pr( "Most importantly - what gender do you see#yourself as? Not just biologically, but mentally,#spiritually? Who are you?" ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
		add_child(cc_gender)
		await cc_gender.accept_pressed
		
	if not skip_alignment:
		cc_textbox.display_text( Text.pr( "We all live by codes, whether or not we realize it.#Some struggle to uphold the values of our society#- the lawful - while others choose to follow their#whims and desires - the chaotic." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "Some reach outward through acts of charity and#kindness - the good - and others delve inward,#indulging in the pleasures of our earthly existence#- the evil." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "It has been said that the differences between#these groups - ah, no, these... archetypes, these#fundamental paradigms of human capability - are#irreconcilable." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "I do not believe so - but I digress." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "I will make a series of statements and I will ask you#whether you agree, disagree or have no opinion#at all. It is through this method we will determine#the code by which you live." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()

	if not skip_alignment_questions:
		add_child(cc_alignment)
		var death : bool = await cc_alignment.input_finished
		
		# you chose strongly agree on option 12
		if death:
			# stupid options, rarely seem by anione. took me about 1 hour to port with minimal effort.
			var death_scene = cc_death.instantiate()
			add_child(death_scene)
			await death_scene.stopped_smoke
			cc_alignment.queue_free()
			
			cc_textbox.display_text( Text.pr( "And I had such great hopes for you... I suppose#we shall just have to wait for a new champion to#arise. Goodbye " + str( B2_Playerdata.character_name )+ "..." ) )
			await cc_textbox.finished_typing
			cc_textbox.texbox_hide()
			
			var tween := create_tween()
			tween.tween_interval(5)
			tween.parallel().tween_property(self, "modulate", Color.BLACK, 5.0)
			tween.tween_property(self, "modulate.a", Color.TRANSPARENT, 5.0)
			tween.tween_interval(2.5)
			tween.tween_callback( get_tree().quit )
			
			await tween.finished
			
		
		await get_tree().create_timer(1).timeout
		
		cc_textbox.display_text( Text.pr( "Yes, it is all becoming very clear now. Your#answers have revealed to me the fundamental core#of your beliefs. You are..." ) )
		await cc_textbox.finished_typing
		
		var character_alignment_x := B2_Playerdata.character_alignment_x
		var character_alignment_y := B2_Playerdata.character_alignment_y
		print("alignment x: ",character_alignment_x)
		print("alignment y: ",character_alignment_y)
		
		## Good
		if character_alignment_x >= 0 and character_alignment_x <= 2:
			## Lawful
			if character_alignment_y >= 0 and character_alignment_y <= 2:
				cc_textbox.display_text( Text.pr( "Lawful Good. You are a paragon of virtue, morality#and order on the chaotic streets of the#Post-Cyberpocalypse." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You routinely put others before yourself and#always act out of a sense of honor and compassion.#You feel it is your duty to protect those that can't#protect themselves." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Lawful Good is the alignment most found in#nanorevelators and digital Magi. Dracula and#Popeye are both Lawful Good." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
			## Neutral
			if character_alignment_y >= 3 and character_alignment_y <= 6:
				cc_textbox.display_text( Text.pr( "Neutral Good. People who are Neutral Good follow#their conscience and code of ethics but do not#necessarily feel obligated to do so within the#boundary of the law." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You feel that the law is a good thing, but can be#misused in the wrong hands. You generally try to#defend the poor and weak of the#Post-Cyberpocalypse." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Neutral Good is the alignment most found in#cyberpilgrims and Afrofuturists. Dracula and#Popeye are both Neutral Good." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
			## Chaotic
			if character_alignment_y >= 7 and character_alignment_y <= 9:
				cc_textbox.display_text( Text.pr( "Chaotic Good. You follow a strict moral code of#helping others and social justice. You believe that#government and authority hinder the general#welfare and often find yourself at odds with -" ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( " - bureaucracy. Many consider you to be a#Post-Cyberpocalyptic Robin Hood. Chaotic Good is#the alignment most found in hacktivists and#cracktivists." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Dracula and Popeye are both Chaotic Good." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
		## Neutral
		if character_alignment_x >= 3 and character_alignment_x <= 6:
			## Lawful
			if character_alignment_y >= 0 and character_alignment_y <= 2:
				cc_textbox.display_text( Text.pr( "Lawful Neutral. You believe firmly that law is the#only thing that keeps the Post-Cyberpocalypse#from permanently imploding into chaos." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "For you, morality is not part of the equation, only#that justice as dictated by the CyberNET Mainframe#is executed. Lawful Neutral is the alignment most#found in technosavants and cryptoartificers." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Dracula and Popeye are both Lawful Neutral." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
			## Neutral
			if character_alignment_y >= 3 and character_alignment_y <= 6:
				cc_textbox.display_text( Text.pr( "True Neutral. Most of the wayfarers who traverse#the CyberNET Mainframe aren't attached to any#strict ideology or belief system." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You understand the harsh realities of Augmented#Reality, appreciate that all humans share in their#suffering, and have adopted a live-and-let-live#approach to the Post-Cyberpocalypse." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Dracula and Popeye are both True Neutral." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
			## Chaotic
			if character_alignment_y >= 7 and character_alignment_y <= 9:
				cc_textbox.display_text( Text.pr( "Chaotic Neutral. You believe strongly that all#people should be free to live how they choose and#that no authority can dictate right from wrong." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Good and evil are nebulous, artificial concepts,#often one in the same, and it is disingenuous to#try to categorize all human behavior as one or the#other. You tend to favor bitcoins." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Chaotic Neutral is the alignment most found in#cryptozauberists and virtual smugglers. Dracula#and Popeye are both Chaotic Neutral." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
		## Evil
		if character_alignment_x >= 7 and character_alignment_x <= 9:
			## Lawful
			if character_alignment_y >= 0 and character_alignment_y <= 2:
				cc_textbox.display_text( Text.pr( "Lawful Evil. You work within the boundaries of the#law to serve yourself. You find the easiest and#best way to gain power is through climbing the#hierarchy and exploiting the people beneath you." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Kindness and charity do not matter to you and you#are not averse to manipulating the law or abusing#loopholes to get what you want. Lawful Evil is the#alignment most found in cybershaman." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Dracula and Popeye are both Lawful Evil." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
			## Neutral
			if character_alignment_y >= 3 and character_alignment_y <= 6:
				cc_textbox.display_text( Text.pr( "Neutral Evil. You exist solely to serve yourself#and view people as stepping stones to further#your personal goals." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "You have no problem acting outside the law but#you do not revel in anarchy like those of the#Chaotic alignment. You do not help others unless#you directly benefit from it." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Neutral Evil is the alignment most found in digital#yeomen and webmasters. Dracula and Popeye are#both Neutral Evil." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
			## Chaotic
			if character_alignment_y >= 7 and character_alignment_y <= 9:
				cc_textbox.display_text( Text.pr( "Chaotic Evil. You do whatever you want whenever#you want with no thought of consequences or the#people you hurt. You are aggressive, impulsive and#enjoy destruction for its own sake." ) )
				await cc_textbox.finished_typing
				cc_textbox.display_text( Text.pr( "Chaotic Evil is the alignment most found in#datamancers, B.I.O. guerrillas and techno#decapitators. Dracula and Popeye are both Chaotic#Evil." ) )
				await cc_textbox.finished_typing
				cc_textbox.texbox_hide()
		
	##breakpoint
		
		
#text[1] = "Tell me about yourself... Yes, your name... What is#your name?";   
#text[2] = "Yes, an ancient name... a noble name. It has been#some time since I've heard that name. And yet, I#knew you carried it as soon as I laid eyes on you.";
#text[3] = "It is a name that bears much strength, but also#much sorrow. It is a name with a tragic history, a#glorious history. And it is a name with history yet#unwritten...";   
#text[4] = "Now answer me these questions, " + o_cc_data.character_name + "."; 
