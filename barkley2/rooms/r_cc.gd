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
@export var skip_crest := false
@export var skip_tarot := false
@export var skip_gumball := false


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
@onready var cc_crest 		= preload("res://barkley2/scenes/CC/cc_crest.tscn").instantiate()
@onready var cc_tarot 		= preload("res://barkley2/scenes/CC/cc_tarot.tscn").instantiate()
@onready var cc_gumball 	= preload("res://barkley2/scenes/CC/cc_gumball.tscn").instantiate()

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
		wiz_hands()
	
func wiz_hands():
	if not skip_hands: # Wizard waves its hands and talks a lot.
		cc_textbox.display_text( Text.pr( "Greetings, young one. I have been awaiting your#arrival for some time now. The world has been#waiting for your arrival. Ah, but my manners...#Please, take a seat and make yourself comfortable.") )
		await cc_textbox.finished_typing
		
		cc_textbox.display_text( Text.pr( "Tell me about yourself... Yes, your name... What is#your name?") )
		await cc_textbox.finished_typing
		
		cc_textbox.texbox_hide()
		await cc_textbox.visibility_changed
	wiz_name()
	
func wiz_name():
	if not skip_name: # name prompt apears, waiting for you to type yourt name.
		add_child( cc_name )
		await cc_name.name_entered
	wiz_zodiac_pre_dialog()
		
func wiz_zodiac_pre_dialog():
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
	wiz_zodiac_input()
		
func wiz_zodiac_input():
	if not skip_zodiac_input:
		# Show a black screen, add cc_zodiac
		await darken_screen( true )
		add_child(cc_zodiac)
		await darken_screen( false )
		
		# wait for the player to set the cc_zodiac
		await cc_zodiac.zodiac_entered
		
		# Show a black screen, remove cc_zodiac
		await darken_screen( true )
		remove_child(cc_zodiac)
		await darken_screen( false )
		
	wiz_zodiac_pos_dialog()
	
func wiz_zodiac_pos_dialog():
	if not skip_zodiac_pos_dialog:
		# holy shit, I hate this! vvvvvv
		assert( B2_Playerdata.character_zodiac in range(1,13) )
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
			_:
				breakpoint
				
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
	wiz_blood()
				
func wiz_blood():
	if not skip_blood:
		cc_textbox.display_text( Text.pr( "And what blood runs through your veins?" ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
		await get_tree().create_timer(1.0).timeout
		add_child( cc_blood )
		await cc_blood.accept_pressed
		#remove_child( cc_blood )
		await get_tree().create_timer(1.0).timeout
		
		cc_textbox.display_text( Text.pr( "Yes, yes... the blood of warriors, the blood of kings.#Your heritage is one of greatness and it confers in#you much strength. Perhaps enough to save us all..." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		await get_tree().create_timer(1.0).timeout
		
	wiz_gender()

func wiz_gender():
	if not skip_gender:
		cc_textbox.display_text( Text.pr( "Most importantly - what gender do you see#yourself as? Not just biologically, but mentally,#spiritually? Who are you?" ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
		add_child(cc_gender)
		await cc_gender.accept_pressed
	wiz_alignment()
		
func wiz_alignment():
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
	wiz_alignment_questions()

func wiz_alignment_questions():
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
			tween.tween_property(self, "modulate:a", Color.TRANSPARENT, 5.0)
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
				
	await get_tree().create_timer(1.0).timeout
	wiz_crest()

func wiz_crest():
	if not skip_crest:
		cc_textbox.display_text( Text.pr( "Your family crest represents where you've come#from and who you are. Draw your family's#heraldry on this shield." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
		add_child( cc_crest )
		await cc_crest.crest_finished
		await get_tree().create_timer(1).timeout
		
		cc_textbox.display_text( Text.pr( "Yes, yes... interesting. There is an understated#dignity to your family crest, hints of a noble and#glorious past. Yes, your heraldry truly depicts the#greatness of your line." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "And perhaps... it portends an even greater future." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
	await get_tree().create_timer(1.0).timeout
	wiz_tarot()
		
func wiz_tarot():
	if not skip_tarot:
		add_child(cc_tarot)
		
		cc_textbox.display_text( Text.pr( "Gaze upon these cards I hold in my hand, my child.#More than mere playing cards, the tarot are#indescribably powerful divinatory tools, a product#of ancient Hermetic wizards who sought the true, -" ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "- forbidden knowledge of humanity and the greater#universe through the invokation of their god Thoth." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "The eternal figures that emblazon these card faces#are but notes singing the ancient refrain that has#endlessly reverberated in the minds of mankind#since our descent from the stars." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "They provide a conduit between the earthly domain#we inhabit and the oceanic depths of our collective#unconscious, and the drawing of these cards#forges an inviolable covenant between the -" ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "- endless past, your boundless destiny, and the#divine energies which shape our untold future." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "With this warning, I ask that you choose one card#at a time from the four that I will place in front of#you." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "The first card drawn is very important. Take its#image into your mind, and hold it close to your#heart." ) )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "This is the Significator, and will serve as your#representation, or avatar, within this mystic#tableau." ) )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		
		cc_tarot.hide_cards()
		await cc_tarot.cards_hidden
		cc_tarot.card_selected.connect( wiz_tarot_parse_drawn_card )
		
	else: 
		cc_tarot.queue_free()
		await get_tree().create_timer(1.0).timeout
		wiz_gumball()
		
func wiz_tarot_parse_drawn_card( card_id : int, cards_picked : int ):
	var text_card := Array()
	print("card_id: ", card_id)
	print("cards_picked: ", cards_picked)
	match card_id - 2: ## Offset due to the frame 0 and 1 being the back of the card.
		0:
			text_card.resize( 5 )
			text_card[0] = "A great current of wind sends you hurtling through#the air. Your helpless body swings this way and#that, without reason. You are a leaf on a blustering#wind."; 
			text_card[1] = "You cease motion on a branch on a tree on a hilltop,#for a moment, then you're off."; 
			text_card[2] = "... " + str(B2_Playerdata.character_name) + "... " + str(B2_Playerdata.character_name) + "!"; 
			text_card[3] = "Did you fall asleep on me? It is important you#concentrate on the reading! The fool in the#Present."; 
			text_card[4] = "The fool lives in and savors an ever-changing#present, with no thought of the past, the forces of#Air propelling him into the future."; 
		1:
			text_card.resize( 2 )
			text_card[0] = "Our story begins at twilight, when the Moon rises#in the sky to begin reflecting, and the Popess'#visions are strongest. She beckons you towards#her, to inhabit the spot between two pillars."
			text_card[1] = "You are safe here, for the present. When you find#yourself in sanctuary, direct your learning#inwards, like the Popess. Solitude and self-#awareness are the path to her conduit with God."; 
		2:
			text_card.resize( 2 )
			text_card[0] = "Ah, the lovely Empress smiles! The most fecund of#cards. Mother Earth offers forth her bounty. Figs,#dates, and satsumas abound.";
			text_card[1] = "The numeral III indicates the stability and hardiness#of nature, as well as its dynamism. The Vines are#heavy-laden with grapes, and the Empress squashes#them to wine with her mighty gams."; 
		3:
			text_card.resize( 3 )
			text_card[0] = "On this day, the Emperor rules. Your journey will#take you through the jurisdictions of powerful#authorities and dynasties."; 
			text_card[1] = "The scepter in the elder dwarf's right hand#indicates the Emperor's strict orthodoxy, and his#left-hand globus is his reserved, spontaneous#might. Befriend these powers or beware them."; 
			text_card[2] = "Do neither, and bemoan your pitiful end.";
		4:
			text_card.resize( 3 )
			text_card[0] = "The hierophant has devoted his life to Clispaeth. He#subjects his body and soul to extreme trials, and#renews himself with his unwavering piety."; 
			text_card[1] = "His disquieting presence is an indication of how far#he has passed outside of this world and into a#divine one."; 
			text_card[2] = "Imitating his spiritual ardor and legendary humility#will be fruitful if you face like ordeals.";
		5:
			text_card.resize( 2 )
			text_card[0] = "Lovers. Two beings in constant interaction, whose#whole reality is dependent on that of the other.#The arena you step into is shifting and dynamic.#There is another side to everything." 
			text_card[1] = "Causality will be hard to pin down, so claim the#advantage by anticipating this. Banana trees#indicate pride and its other half, shame."
		6:
			text_card.resize( 1 )
			text_card[0] = "The nature of the world is that of the Chariot.#Wheels within wheels, constantly turning. Make#each of your moments count. That's all this card#says."; 
		7:
			text_card.resize( 1 )
			text_card[0] = "Equilibrium… set the scales off balance?"; 
		8:
			text_card.resize( 3 )
			text_card[0] = "The hermit! We are in an era of solitude, but under#His watchful eye in the Valley of the Hermit. Want#something more exciting?" 
			text_card[1] = "The Hermit is the patron card of all loners, exiles,#bad boys, rebels and outcasts of yesterday and#today.";
			text_card[2] = "All bosozoku, raggare, and greasers receive a#passive initiative bonus, extending to the end of#their next recovery phase."; 
		9: ## ATTENTION
			text_card.resize( 1 )
			text_card[0] = "This card doesn't tell us much with nothing else on#the table. May I draw another?"; 
			## TODO Present special screen
			
		10:
			text_card.resize( 2 )
			text_card[0] = "Barbarians, brigands, and brasters rejoice! Might#flexes his muscle before us. Lifting, carrying, and#toting. Pushing, pulling, and shoving. Tossing,#throwing, and hurling." 
			text_card[1] = "These actions and more fall under dominion of#Might. What will you tote?"
		11:
			text_card.resize( 2 )
			text_card[0] = "A falling motion, inversion, hanging, waiting,#'hanging out'. The environment is out of balance,#in fact, the opposite of way things could be. I#wouldn't worry about it, " + str(B2_Playerdata.character_name) + "."; 
			text_card[1] = "It could be that the world is waiting for you to#right it, but try seeing if you can get along well#within it, even if it's not something you're used#to. The letter M and water elementals."; 
		12:
			
			text_card.resize( 3 )
			text_card[0] = "Low-intoned speech whispered between covens#suggests that every time you turn over a Death#card, someone, somewhere, perishes at the exact#moment.";
			text_card[1] = "Does the drawing of the card force the actual#death to occur, or vice versa? Is it just a#statistically-ensured probability, given the#enormous size of the universe?"; 
			text_card[2] = "That's all I can think about when this card arrives#here."; 
		13:
			text_card.resize( 3 )
			text_card[0] = "Temperance, as a member of the Tarot, strikes a#balance. Immediately a let down when you see it#dealt, but it makes up for this with a few perks.";
			text_card[1] = "Along with boredom is volatility... perfect blandness#cannot be achieved without its constituent#elements constantly reacting in perfect synthesis.";
			text_card[2] = "The dwarf on the card slowly churns butter. A#deliberate, measured churn returns the highest#creamy yield, Remember this, my child."; 
		14:
			text_card.resize( 2 )
			text_card[0] = "Please, speak in hushed tones about the era of the#Devil! The dark lord's sigil has aligned itself over#the cosmic torus. Saturn's ring ignites in white#flame."; 
			text_card[1] = "Ambition, wickedness, and sulphurous vapours are#the hallmark of this dismal time."; 
		15: ## ATTENTION
			text_card.resize( 4 )
			text_card[0] = "An ominous sign. The Crack'd Dome. Something is#fractured and edges closer to complete#obliteration."; 
			text_card[1] = "I can't tell what it is - an open seam, metaphysical#glitch, or foreign entity - but it is terribly wrong,#and only getting worse."; 
			text_card[2] = "You must find this problem and stop it, purge it#from the stream of existence, " + str(B2_Playerdata.character_name) +"."; 
			text_card[3] = "You have no more time to waste here. I'm putting#the cards away now."; 
			## This is a special card. no idea what it does, but it does something.
		16:
			text_card.resize( 4 )
			text_card[0] = "Polaris, the Lodestar guided the ancient Pilgrims#across the seas to their their home in the New#World, at Yerusharim." 
			text_card[1] = "Their crude sextants were fashioned out of animal#furs, chewed sinew, and sod."; 
			text_card[2] = "Hundreds of technological revolutions later,#modern Cyberpilgrims can be gravitationally guided#by any of trillions of stars."; 
			text_card[3] = "Still, the star’s role remains the same - to watch#over and silently judge us, cruel voyeurs of#history. This uneasy give-and-take between man#and star has persisted for eons. Is change coming?"; 
		17:
			text_card.resize( 4 )
			text_card[0] = "The moon card is the most potent symbol of wisdom#in the tarot, and also a symbol of madness.";
			text_card[1] = "Much like how moonlight is originally the sun's,#and not its own, so is the wisdom we find in the#moon just a mirror of our own intuition."; 
			text_card[2] = "In the river, we can see the reflection repeated,#and of course, distorted. Mirroring of mirrors#continually confuses and separates the vision#of the original source.";
			text_card[3] = "Similarly, we must keep in mind that subjectivity#can ruin the truth in reflection. If you're#looking for answers, be a still surface, and let#the moon look into you, not the other way around.";
		18:
			text_card.resize( 3 )
			text_card[0] = "Yes! What a great omen the sun card is! The look#on the sun's satisfied visage suggests he can do#no wrong. What a beneficent face! The sun makes#the flowers and plants grow.";
			text_card[1] = "Thanks to the sun, it's warm enough to go to the#beach. By harnessing renewable solar energy,#anything made possible by fossil fuels could one#day be run entirely on the sun's clean energy."; 
			text_card[2] = "There's nothing in this world that the sun doesn't#have a hand in. This is a really great draw,#youngster. I mean it.";
		19:
			text_card.resize( 3 )
			text_card[0] = "Karma is the ethereal force of judgment and#harmony that pervades existence. It represents#justice on an eternal scale and with a focus that#is individual and universal at once.";
			text_card[1] = "Maybe drawing this card doesn't mean much to you,#but I believe what it is trying to tell you is that#everything that occurs is known to occur.";
			text_card[2] = "The world is not meaningless! Everything that#comes to pass today will come to pass again. What#you do on your journey will be remembered, child."; 
		20:
			text_card.resize( 3 )
			text_card[0] = "The universe card is the final card in the tarot#deck. It represents finality and totality. The end,#and everything at the end.";
			text_card[1] = "Your journey has not yet begun, and yet I can tell#you are destined for many great adventures. Who#knows where they will take you? Wherever you go,#I would hesitate to think of an 'end,' youngster.";
			text_card[2] = "You have so far to go and infinite potential.#Wherever your journey concludes, I don't think it#will be the 'end' for you."; 
		21: # Babe!
			text_card.resize( 3 )
			text_card[0] = "Oh my... what you have drawn just now is the fabled#babe in the woods... Without more context I cannot#tell what this card signifies for you or the journey#ahead of you but..."; 
			text_card[1] = "Do not be alarmed, youngster. It is not an ill omen#that you have drawn this card. More so it is a#mystery, much like the babe itself. Why is the babe#in the woods? Who put the babe in the woods?"; 
			text_card[2] = "Are there more babes abound, or is this the only#one? This card predicts a deep pondering and self-#discovery in your future, youngster."; 
		22:
			text_card.resize( 2 )
			text_card[0] = "Ah, the Official Rules! It looks like fate is#smiling upon you, youngster. This card represents#society becoming more than the sum of its parts,#guided by justice and the rule of law."; 
			text_card[1] = "I have no doubt that in time you too will find#greatness within yourself, but only by abiding the#rules that your elders have laid out for you..."; 
		23: 
			text_card.resize( 1 )
			text_card[0] = "Oh, look youngster! Look what you have drawn!#Treasure, gemstones and goblets... Epic loot!#Greatest of fortunes will be bestowed upon you.#That is what this card tells me.";
		24:
			text_card.resize( 4 )
			text_card[0] = "Ah, the card of the juggler. It seems that nearly#every culture has its own juggling legends, and#this archetypical figure is usually depicted as a#crafty rogue who dazzles god and man alike with - ";
			text_card[1] = " - a fusion of dynamic sporting moves and#entertainment sensibility. His accompanying form is#the dark juggler, a malevolent acrobat who tosses#its bowling-pins and kerchiefs with ill-intent.";
			text_card[2] = "Notice the juggler's workshop spans a river. The#river's mists imply Maya, the fog of illusion that#hangs over the sporting world.";
			text_card[3] = "Both jugglers and dark jugglers alike profess that#they are looking for the truth. It will be up to you#to decide who you believe.";; 
		25:
			text_card.resize( 5 )
			text_card[0] = "Shown here is the mountebank, a fiend in the guise#of a knave. The mountebank is talented at knowing,#and tirelessly schemes to gain advantages through#control of the forces of knowledge and ignorance."; 
			text_card[1] = "Notice that his worktable spans a river, suggesting#Lethe. It forms a bridge between the world of#memory and amnesia. With his deck, the mountebank#can divine truths with the tarot, or deceive -";
			text_card[2] = " - others in his treasured game, Monte. See the#candle with which he can selectively illumine truths,#and the three magic mirrors that grant him#perspective. He is also armed with a cup of -";
			text_card[3] = " - intoxicating tinctures. The mountebank is a#cheater, of course. His red scarf of guilt clings to#his neck like an albatross.";
			text_card[4] = "It would be wise to advance prudently in your#pursuit of knowledge, youngster.";
		26:
			text_card.resize( 4 )
			text_card[0] = "Shown here is the magician, a figure of arcane#power. The magician, through study and sacrifice,#has conquered the divide between the world of#thoughts and that of physical existence."; 
			text_card[1] = "His alchemical rites use the power of word and#ideal to twist and shape the universe. Notice that#his worktable spans a river. The magician's sorcery#creates a bridge between the phenomenal and -";
			text_card[2] = " - noumenal worlds. With his magic wand, the#magician levitates three azure zaubers. All are#glowing with the divine spark.";
			text_card[3] = "The clear absence of jugglers in this picture#precludes juggling as an explanation. An#admittedly shallow read suggests zaubermancy in#your future... could it be?";
			
	## Zodiac modifiers
	match B2_Playerdata.character_zodiac_index:
		0: # // Aries //
			text_card.append( "Like you, the Emperor card looks skyward to the#Aries constellation. Take note of this. Perhaps the#power they wield is there for your usurpation?" )
		1: # // Taurus //
			text_card.append( "Imitating his spiritual ardor and legendary humility#will be fruitful if you face like ordeals. Taurus#grounds, lends bull energy." )
		2: # // Gemini //
			text_card.append( "Causality will be hard to pin down, so claim the#advantage by anticipating this. Gemini, your#traditional duality is now quadrality. Banana#trees indicate pride and its other half, shame." )
		3: # // Cancer //
			text_card.append( "The nature of the world is that of the Chariot.#Wheels within wheels, constantly turning." )
			text_card.append( "Earths and galaxies spin through space and time,#and we witness the cycles of nature, life and death,#death and rebirth… as represented by Chariot’s twin steeds,#Dimensionality and Metempsychosis." )
			text_card.append( "Make each of your moments count. That's all this#card says." )
		4: # // Leo //
			text_card.append( "Barbarians, brigands, and brasters rejoice! Might#flexes his muscle before us. Lifting, carrying, and#toting. Pushing, pulling, and shoving. Tossing,#throwing, and hurling." )
			text_card.append(  "These actions and more fall under dominion of#Might. And it seems Might has left indelible imprint#on your past." )
			text_card.append( "The dim, throbbing light in your eye tells of a#mighty event not long ago, an eruption of might#whose effects wracked the cosmos and stretch#to the present." )
			text_card.append( "Such pure might... pursuit of this might is the game,#" + str( B2_Playerdata.character_name ) + ", and the pieces are set." )
			text_card.append( "Which will you tote?" )
		5: # // Virgo //
			text_card.append( "Virgins, monks, and hikkikomori earn the same and#get a unique trophy." )
		6: # // Libra //
			pass
		7: # // Scorpio //
			text_card.append( "That's all I can think about when this card arrives#here. I don’t think the Death card would hurt you,#though." )
		8: # // Ouphicius //
			pass
		9: # // Sagittarius //
			text_card.append( "Hold... I see butter reflected in your wan#complexion. Interesting..." )
		10: # // Capricorn //
			text_card.append( "Ambition, wickedness, and sulphurous vapours are#the hallmark of this dismal time. Those aligned to#Capricorn - bearers of great sins - feel the loads#of guilt they carry lightening." )
		11: # // Aquarius //
			text_card.append( "Is… is it you?" )
		12: # // Pisces //
			pass

	for text in text_card:
		cc_textbox.display_text( Text.pr( text ) )
		await cc_textbox.finished_typing
	cc_textbox.texbox_hide()
	
	if card_id == 11:
		var warning 			= preload("res://barkley2/scenes/CC/warning_bg.tscn").instantiate()
		warning.button_space	= 20.0
		warning.popup_warning 	= ""
		warning.popup_yes 		= Text.pr("New card");
		warning.popup_no 		= Text.pr("Keep it");
		add_child(warning)
		var choice = await warning.choice_has_been_made
		
		if choice == true:
			cc_tarot.shuffle_cards()
			return
			
	# Force the tarot  script to end
	if card_id == 17:
		cards_picked = 3
		
	await get_tree().create_timer(0.5).timeout
	match cards_picked:
		0:
			cc_textbox.display_text( Text.pr( "The card you draw next is the Herald, and will give#us a glimpse into your future." ) )
			await cc_textbox.finished_typing
		1:
			cc_textbox.display_text( Text.pr( "Now it is time to draw the Mirror. It will show to you#your deepest desires, or your worst fears." ) )
			await cc_textbox.finished_typing
		2:
			cc_textbox.display_text( Text.pr( "The final card. The World. This card will serve as a#conduit between all the cards that came before it.#All that you have seen here will be linked by the#World." ) )
			await cc_textbox.finished_typing
		3:
			# Finished picking cards
			B2_Playerdata.character_tarot_cards = cc_tarot.card_index ## picked Cards
			await get_tree().create_timer(1.5).timeout
			
			wiz_gumball()
			return
			
	cc_textbox.texbox_hide()
	cc_tarot.card_selection( true ) ## cards can be clicked again.
	
func wiz_gumball():
	if not skip_gumball:
		# Fade do black, add gumball, fade back.
		fade_texture.show()
		fade_texture.color.a = 0.0
		var t_tween := create_tween()
		t_tween.tween_property( fade_texture, "color:a", 1.0, timer_alpha_in )
		t_tween.tween_callback( cc_tarot.queue_free ) ## Cleanup
		t_tween.tween_callback( add_child.bind(cc_gumball) )
		t_tween.tween_property( fade_texture, "color:a", 0.0, timer_alpha_in )
		await t_tween.finished
		fade_texture.hide()
		
		## Gumball vars (maybe unneeded)
		var cc_quarter_choice = false;
		var quarter_scale = 0;
		var gumball_coin := false; ## // If 1 you took coin ## you got the coin, but chose not to use it.
		var gumball_abstain := false; ## // If 1 you abstained ## You denied the gumball. absolute madlad.
		var gumball_animation = 0;
		var gumball = 0;
		var gumball_choice := -1; ## // was 0;
		
		cc_textbox.display_text( Text.pr( "You are a candy enthusiast - am I correct? Ah,#yes... a gumball lover! Surely you'd like a gumball,#wouldn't you?" ) )
		await cc_textbox.finished_typing
		cc_textbox.display_question( Text.pr( "What do you say, do you want a gumball?" ), "Yes", "No" )
		var choice = await cc_textbox.awnsered_question
		if choice:
			# Take the gumball
			cc_textbox.display_text( Text.pr( "Ah, I thought so! I also enjoy the occasional#gumball. Here, take this quarter. It will aid your#endeavor to acquire a gumball." ) )
			await cc_textbox.finished_typing
			cc_textbox.texbox_hide()
			
			cc_gumball.show_quarter()
			await cc_gumball.quarter_anim_finished
			
			var warning 			= preload("res://barkley2/scenes/CC/warning_bg.tscn").instantiate()
			warning.popup_color		= Color.RED
			warning.button_space	= 20.0
			warning.popup_warning 	= Text.pr("WARNING!##Only one quarter remaining.#Continue anyway?")
			warning.popup_yes 		= Text.pr("Yes");
			warning.popup_no 		= Text.pr("No");
			add_child(warning)
			
			## TODO quarter animation
			
			var quarter_choice : bool = await warning.choice_has_been_made # false ## false is TEMP. TODO add quarter choice
			if quarter_choice:
				# Use the quarter
				## TODO add gumball animation
				cc_gumball.drop_gumball()
				var ball_chosen : int = await cc_gumball.gumball_anim_finished
				
				match ball_chosen:
					0: ## // Werthers //
						cc_textbox.display_text( Text.pr( "How fortunate you are! This butterscotch gumball#has a delectable caramel flavor. It also shares#a color with a fabled candy: Werther's Original.#Imagine, a Werther's Original gumball..." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_text( Text.pr( "If only we could be so blessed!" ) )
						await cc_textbox.finished_typing
						## TODO
						
					1: ## // Foul //
						cc_textbox.display_text( Text.pr( "Disgusting... an ancient, weathered gumball,#wearing scars earned from millenia of erosion#and decay." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "This antediluvian gumball is surely a cursed relic#which will bring about misfortune. Shall I destroy it?" ), Text.pr("Destroy the gumball immediately!"), Text.pr("I want to keep this gumball") ) ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						gumball_choice = flavor_choice
						
						if flavor_choice: # // Foul destroy //
							cc_textbox.display_text( Text.pr( "Good. Such a foul gumball should not be permitted#to exist!" ) )
							await cc_textbox.finished_typing
						else: # // Foul keep //
							cc_textbox.display_text( Text.pr( "You fool! No good can come from that ball..." ) )
							await cc_textbox.finished_typing
						
					2: ## // Transparent //
						cc_textbox.display_text( Text.pr( "How curious, a fully transparent gumball. What#magic or natural processes created this gumball#may never be known, but we've been given a rare#window into an heretofore unseen microcosm." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_text( Text.pr( "A truly priceless artifact for any gumball hobbyist#or scholar." ) )
						await cc_textbox.finished_typing
						## TODO
						
					3: ## // Winner //
						cc_textbox.display_text( Text.pr( "Congratulations, child! The recipient's ownership#and then subsequent forfeiture of this WINNER#gumball to a contest organizer entitles the#recipient to one prize." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_text( Text.pr( "Let it be known, you're in a very enviable position#while you possess this gumball." ) )
						await cc_textbox.finished_typing
						## TODO
						
					4: ## // Steel //
						cc_textbox.display_text( Text.pr( "How did that get there?... a solid steel gumball! I#don't envy your pockets, youngster! Let's hope#they're double-stitched if they're going to be#laden with this weighty gumball." ) )
						await cc_textbox.finished_typing
						## TODO
						
					5: ## // Red //
						cc_textbox.display_text( Text.pr( "Nothing makes you feel young again quite like a red#gumball. This sanguine gumball arouses slumbering#memories with its bold looks and classic fruit#flavor." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "What gumball from your past do you wish to#remember?" ), Text.pr("Strawberry"), Text.pr("Cherry")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // Red - Strawberry //
							cc_textbox.display_text( Text.pr( "Delicious choice. But keep in mind, the delicate skin#of a strawberry gumball can bruise easily from the#slightest impact. I think you need to chew it,#pronto." ) )
							await cc_textbox.finished_typing
						else: # // Red - Cherry //
							cc_textbox.display_text( Text.pr( "So, you prefer the complex, dusky taste of a#cherry gumball, do you? I can tell you made that#choice after much deliberation, my child. Your#wrinkled brow betrays your consternation." ) )
							await cc_textbox.finished_typing
							cc_textbox.display_text( Text.pr( "Thankfully, the act of making any decision at all#usually lightens the burden." ) )
							await cc_textbox.finished_typing
							
						## TODO
						
					6: ## // Yellow //
						cc_textbox.display_text( Text.pr( "A gleaming gumball, the color of the sun. It would#be prudent to expect a bright, perhaps illuminating#flavor from a yellow gumball. It is nearing dawn.#Take it in your hand." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "You should feel your hopes rising with the sun.#What flavor are your hopes set on?" ), Text.pr("Banana"), Text.pr("Lemon")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // Yellow - banana //
							cc_textbox.display_text( Text.pr( "Then I trust that's what you'll find, youngster.#Banana is a common flavor in the gumball canon.#It's banana, undoubtedly." ) )
							await cc_textbox.finished_typing
						else: # // Yellow - Lemon //
							cc_textbox.display_text( Text.pr( "So, you prefer the complex, dusky taste of a#cherry gumball, do you? I can tell you made that#choice after much deliberation, my child. Your#wrinkled brow betrays your consternation." ) )
							await cc_textbox.finished_typing
							cc_textbox.display_text( Text.pr( "Interesting. Even... quite interesting. A lemon#gumball... by Clispaeth..." ) )
							await cc_textbox.finished_typing
						## TODO
						
					7: ## // Blue //
						cc_textbox.display_text( Text.pr( "What a splendid find! Your new blue gumball#glitters on the horizon like the Ishtar Gate, a#timeless monument of flavor. What fruit is depicted#in the bas-relief adorning this mighty gumball?" ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "What flavor do you expect thig gumball to be?" ), Text.pr("Blueberry"), Text.pr("Raspberry")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // Blue - Blueberries //
							cc_textbox.display_text( Text.pr( "Right you are. The chaotic war scenes on the south#side of the gumball transition through detailed#scenes of manufacturing and eventually tranquil#depictions of domestic life in antiquity." ) )
							await cc_textbox.finished_typing
							cc_textbox.display_text( Text.pr( "That each of these scenes revolves around#blueberries is a testament to their vast economic#clout, and this sculpture's hidden truth." ) )
							await cc_textbox.finished_typing
						else: # // Blue - Raspberries //
							cc_textbox.display_text( Text.pr( "Indeed, indeed. The pastoral scenes that grace#this indigo treat clearly depict blue raspberries." ) )
							await cc_textbox.finished_typing
							cc_textbox.display_text( Text.pr( "In particular, the sculptures of villagers casting#lots demonstrates the ritual and legal importance#of the blue raspberry to early civilization." ) )
							await cc_textbox.finished_typing
						## TODO
						
					8: ## // White //
						cc_textbox.display_text( Text.pr( "A white gumball, nature's pearl. Some say this#shimmering husk is all that remains of a gumball#when its flavor has been fully drained. They're#commonly derided as 'dead gumbs'." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "But what say you, my child? Examine the gumball.#How much flavor still remains?" ), Text.pr("There is no flavor left"), Text.pr("There is still flavor left")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // White - No flavor //
							cc_textbox.display_text( Text.pr( "Your supposition is almost certainly correct,#youngster. It's doubtful there's even a single#flavor to be found in this, the palest gumball." ) )
							await cc_textbox.finished_typing
						else: # // White - Flavor //
							cc_textbox.display_text( Text.pr( "I trust your keen senses. If you suspect the#presence of a flavor locked within this alabastrine#gumball, I'll take your word for it." ) )
							await cc_textbox.finished_typing
						## TODO
						
					9: ## // Green //
						cc_textbox.display_text( Text.pr( "Ah, look what we have here! A deep green gumball.#The color of vegetation and nature... this gumball#must be a fruit! But I shall let you tell me what#the flavor is." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "So youngster, which fruit flavor lies inside this#ball?"  ), Text.pr("Apple"), Text.pr("Watermelon")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // Green - Apple //
							cc_textbox.display_text( Text.pr( "Yes, chomping into this sour apple gumball will#deliver an extremely satisfying noise and an#equally satisfying crunch, but its tartness will#surely pucker your lips. Be wary, little one." ) )
							await cc_textbox.finished_typing
						else: # // Green - Watermelon //
							cc_textbox.display_text( Text.pr( "Yes, yes of course! The green carapace of this#gumball belies a juicy red interior. Perhaps there#are even seeds in a watermelon gumball. You could#be the first one to find out." ) )
							await cc_textbox.finished_typing
						## TODO
						
					10: ## // Orange //
						cc_textbox.display_text( Text.pr( "An orange gumball... tasty, but rather predictable.#What else could an orange gumball be but an orange#gumball? You have both a refined palate and a#refined palette, youngster." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "Tell me, how do you suspect this gumball tastes?#Like the fruit or like the color?"  ), Text.pr("Orange, the fruit"), Text.pr("Orange, the color")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // Orange - fruit //
							cc_textbox.display_text( Text.pr( "Bergamot, blood, Valencia! mandarin, navel,#satsuma!... unfortunately none of these fruits#carry the smoky bouquet or fresh herbal notes of#orange, the color. All in all, a poor choice." ) )
							await cc_textbox.finished_typing
						else: # // Orange- Color //
							cc_textbox.display_text( Text.pr( "You're quite right, this gumball burns with radiant#orange color! The flavor in this gumball is#unmistakeable. Its the crisp bite and inimitable#vibrancy of the color orange." ) )
							await cc_textbox.finished_typing
							cc_textbox.display_text( Text.pr( "I'm extremely pleased with this outcome." ) )
							await cc_textbox.finished_typing
						## TODO
						
					11: ## // Black //
						cc_textbox.display_text( Text.pr( "A magnificent black gumball. These gumballs are#known to plumb the depths of flavor, finally#returning to the surface with impossible bounties." ) )
						await cc_textbox.finished_typing
						cc_textbox.display_question( Text.pr( "What bounty do you suspect lurks inside this#gumball?"  ), Text.pr("Liquorice"), Text.pr("Coffee")  )  ## question
						var flavor_choice : bool = await cc_textbox.awnsered_question
						
						if flavor_choice: # // Black - Liquorice //
							cc_textbox.display_text( Text.pr( "Hmm, you've picked a very heady flavor, licorice.#Few in the world have the intelligence and will to#fully 'grok' its intricacies. I hope you know what#you're getting yourself into, youngster." ) )
							await cc_textbox.finished_typing
						else: # // Black - Coffee //
							cc_textbox.display_text( Text.pr( "I could tell you were a coffee lover, just like#myself. I surmise this jack'd gumball is just the#pick-me-up you'll need for the travails that await#you." ) )
							await cc_textbox.finished_typing
						## TODO
						
					12: ## // Grape //
						cc_textbox.display_text( Text.pr( "Oh Lord, do I ever want that grape gumball. How#I long for that grape gumball! Looks like you know#my weakness now, youngster. Please... let's move#on." ) )
						await cc_textbox.finished_typing
						## TODO
						
						
				
			else:
				# Do not use the quarter
				cc_textbox.display_text( Text.pr( "Oh... you have changed your mind? That is very#interesting... By denying yourself this delicious#treat, you have shown me what incredible restraint#you possess." ) )
				await cc_textbox.finished_typing
				gumball_coin = true
		else:
			# Deny the gumball
			cc_textbox.display_text( Text.pr( "Oh... excuse me. I thought you were a candy#well-wisher, but it seems I was mistaken. I#apologize for the error..." ) )
			await cc_textbox.finished_typing
			gumball_abstain = true
			cc_textbox.texbox_hide()
			## TODO end sequence
	
		cc_textbox.texbox_hide()
		## save data
		B2_Playerdata.character_gumball = gumball_choice ## Save gumball
		
		if gumball_abstain:
			B2_Playerdata.quests("playerCCGumball", "Abstain")
		if gumball_coin:
			B2_Playerdata.quests("playerCCGumball", "Special Coin")
			
		B2_Playerdata.quests("playerCCGumball", cc_gumball.gumExt[gumball_choice] )
		B2_Playerdata.quests("playerCCGumball", cc_gumball.gumNam[gumball_choice] )
	
	await darken_screen( true )
	
	debug_end_cc()
	#breakpoint
	
	
	##breakpoint
		
func darken_screen( action : bool ):
	if action:
		fade_texture.show()
		fade_texture.color.a = 0.0
		var z_tween := create_tween()
		z_tween.tween_property(fade_texture, "color:a", 1.0, timer_alpha_in )
		await z_tween.finished
		return
	else:
		fade_texture.color.a = 1.0
		var z_tween := create_tween()
		z_tween.tween_property(fade_texture, "color:a", 0.0, timer_alpha_in )
		await z_tween.finished
		fade_texture.hide()
		return
		
func debug_end_cc(): ## Debug action the the CC ends
	get_tree().change_scene_to_file( "res://barkley2/rooms/r_title.tscn" )
#text[1] = "Tell me about yourself... Yes, your name... What is#your name?";   
#text[2] = "Yes, an ancient name... a noble name. It has been#some time since I've heard that name. And yet, I#knew you carried it as soon as I laid eyes on you.";
#text[3] = "It is a name that bears much strength, but also#much sorrow. It is a name with a tragic history, a#glorious history. And it is a name with history yet#unwritten...";   
#text[4] = "Now answer me these questions, " + o_cc_data.character_name + "."; 
