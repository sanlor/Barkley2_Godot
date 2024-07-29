extends Control

signal finished_reading
# repeat (18) instance_create(192, 120, o_cc_palm_reading_area);

@onready var s_cc_palm_hand_area = $s_cc_palm_hand/s_cc_palm_hand_area

var question_id 		:= -1 + randi_range(0,2);
var questions_asked 	:= 0;

var text_question := PackedStringArray()
var text_long := Array()
var text_short := Array()

var time_goes_on := 0.0

func _ready():
	
#region data
	text_question.resize( 10 )
	text_long.resize( 10 )
	for i in 10:
		text_long[i] = Array()
		text_long[i].resize(4)
	text_short.resize( 10 )
	for i in 10:
		text_short[i] = Array()
		text_short[i].resize(4)
	
	text_question[0] = "Which line(s) represents your fears?";
	text_question[1] = "Which line(s) represents your desire?";
	text_question[2] = "Which line(s) represents your faith?";
	text_question[3] = "Which line(s) represents your athleticism?";
	text_question[4] = "Which line(s) represents your curiosity?";
	text_question[5] = "Which line(s) represents your charity?";
	text_question[6] = "Which line(s) represents candy?";
	text_question[7] = "Which line(s) represents your virility?";
	text_question[8] = "Which line(s) represents transhumanism?";
	text_question[9] = "Which line(s) represents sitcoms?"

	text_long[0] [0] = 2;
	text_long[0] [1] = "Your fear is great, but it is also justified. The road#ahead is the most dangerous one you have yet#walked and there are times when you must temper#your youthful bravado with fear."; 
	text_long[0] [2] = "But you must not let your fear rule you. Bravery#and fear are not opposites, they are brothers and#it is often one that leads to the other. Carry one#on each shoulder.";

	text_long[1] [0] = 2;
	text_long[1] [1] = "Look at how this line interacts with others,#intersecting, crisscrossing smaller lines. You are#quite ambitious! You know what you want and you#are capable of getting it."; 
	text_long[1] [2] = "Your desires drive you to succeed and the balance#of F.A.T.E. hinges on your success. Take the fruit#that is given to you, but do not forget to plant its#seeds.";

	text_long[2] [0] = 2;
	text_long[2] [1] = "Whether or not you carry your sword, you will#never go unarmed. Faith is the weapon you bear#and it is the weapon with which you will fight your#most difficult battles.";
	text_long[2] [2] = "You are a true soldier of Clispaeth, "+str(B2_Playerdata.character_name)+",#but you must be mindful of those who hold other#faiths. Use it to defend those in need.";

	text_long[3] [0] = 2;
	text_long[3] [1] = "A powerful jock aura exudes from your body. Yes,#your jock energies throb with an extraordinary#intensity. The ball and bat, the sneaker and jersey#- they beckon! Find your sport, "+str(B2_Playerdata.character_name)+".";
	text_long[3] [2] = "Find your sport...";

	text_long[4] [0] = 3;
	text_long[4] [1] = 'I felt a faint tremor as I ran my finger over your #curiosity line. There is an old adage, "curiosity#killed the cat".';
	text_long[4] [2] = "You have a healthy curiosity, fair youngster,#but you must keep it where it belongs.";
	text_long[4] [3] = "Perhaps youngsters are meant to be seen and not#heard...";

	text_long[5] [0] = 2;
	text_long[5] [1] = "You have always believed that kindness is one of#the most important traits a person must possess.#Yes, your kindness lines run deep and indicate#a great wellspring of charity within you.";
	text_long[5] [2] = "Look here - do you see how your kindness line#intersects with your sports line? I cannot say#what this portends, but surely it is no mere#coincidence. Reflect well on this fact, "+str(B2_Playerdata.character_name)+".";

	text_long[6] [0] = 3;
	text_long[6] [1] = 'I see place... a trail... a trail of hearts... each#chalky, pastel heart bears an inscription. Some#of them say "I love you" and others say "Sweet#pea" and yet more say "Time 2 dance".'; 
	text_long[6] [2] = 'Now I see a roll... a roll of pennies? No, no! A roll#of discs, made of the same chalky substance the#hearts were made from. The wrapping on the rolls#say "NECCO".';
	text_long[6] [3] = "Yes, these seem to be NECCO Wafers. I am sorry,#"+str(B2_Playerdata.character_name)+". I cannot tell you what this vision#means.";

	text_long[7] [0] = 3;
	text_long[7] [1] = "Ahh, you are a particularly virile youngster. Your#masculine (or feminine) potency is apparent to#those around you - and impresses them deeply! I#must admit that I too am impressed by your -"
	text_long[7] [2] = "- hardiness and vigor.";
	text_long[7] [3] = "Oh... "+str(B2_Playerdata.character_name)+". Mmm...";

	text_long[8] [0] = 2;
	text_long[8] [1] = "VCRs, tape decks, pocket calculators and even#beepers - they just don't phase you! You're a true#child of technology, your finger on the pulse of#the latest tech trends.";
	text_long[8] [2] = "You've hacked, cracked and even jacked your way#through the digital front line and there's just no#telling what you'll do next! Hey, mind if I page you#next time my zip drive is on the fritz?";

	text_long[9] [0] = 2;
	text_long[9] [1] = "Hmmm... yes... yes... You believe that sitcoms are#the preeminent format of humor and content#delivery, so much that you feel that other mediums#cannot stand up to them!";
	text_long[9] [2] = "You've studied the classics: the Nanny, Method &#Red, Roseanne, Shasta McNasty and even Two and#a Half Men! Yes, you're a true sitcom aficionado!";

	text_short[0] [0] = 2;
	text_short[0] [1] = "You are brave, "+str(B2_Playerdata.character_name)+", or reckless.#I cannot tell you what awaits you, but I know#that it is one of the most fearsome forces in the#galaxy."; 
	text_short[0] [2] = "Fear is one of our most basic compulsions - do#not deny what may save your life.";
	text_short[0] [3] = "";

	text_short[1] [0] = 2;
	text_short[1] [1] = "You walk the path of temperance and asceticism.#Your discipline makes you strong and you will#not be distracted by the indulgences your foes#will surely try tempt you with.";
	text_short[1] [2] = "But the path ahead is one of hardship and#suffering. You must find the desire within#yourself to fight beyond the pain.";
	text_short[1] [3] = "";

	text_short[2] [0] = 2;
	text_short[2] [1] = "Yours is a strong but gentle faith, a conviction#you hold deeply but do not share with others.#Others may not recognize your belief, but#Clispaeth does."; 
	text_short[2] [2] = "So long as you walk the path of humility, your#faith shall be your shield."
	text_short[2] [3] = "";

	text_short[3] [0] = 2;
	text_short[3] [1] = "You are a secret jock, skulking in the shadows of#gymnasiums and stadiums. You doubt your sporting#prowess, too apprehensive to don the sneaker - #but there is one who is not.";
	text_short[3] [2] = "That one is F.A.T.E. You will be confronted by many#sports in the near future, and whether you like#it or not, you will be forced to choose one. Choose#that sport wisely.";
	text_short[3] [3] = "";

	text_short[4] [0] = 1;
	text_short[4] [1] = "Ahh, so you like doing homework, eh? Yes, yes.#Keep up your studies, youngster! Knowledge is key!#Learn ye this, and you will unlock the secret to#success. Believe you me.";
	text_short[4] [2] = "";
	text_short[4] [3] = "";
		
	text_short[5] [0] = 3;
	text_short[5] [1] = "You have a keen survival instinct, " + str(B2_Playerdata.character_name) + ".#You know how to handle yourself and you do not#rely on others."; 
	text_short[5] [2] = "It is your own self-sufficiency that causes you to#look down on those that do not share this quality.#Perhaps charity is something you will learn in the#journey ahead of you."; 
	text_short[5] [3] = "Or perhaps it is something you don't need.";

	text_short[6] [0] = 2;
	text_short[6] [1] = "Candy has played a significant role in your life#thus far and its importance will only continue to#grow in the near future.";
	text_short[6] [2] = "Candies of all sizes and shapes and flavors - even#candy corn - will play a part in your journey. In#what way, I cannot say. I know only that candy#awaits you on your journey."
	text_short[6] [3] = "";

	text_short[7] [0] = 2;
	text_short[7] [1] = "You are yet a youngster with time to grow. Your#father planted the seed of life in your mother's#womb out of love - now that seed is a sapling,#growing stronger and hardier with every day."; 
	text_short[7] [2] = "Love is a powerful force, " + str(B2_Playerdata.character_name) + ". In time,#you too will plant your seed. But for now, you must#continue to grow. We are all very proud of you.";
	text_short[7] [3] = "";

	text_short[8] [0] = 2;
	text_short[8] [1] = "You're open to the idea that people may enhance#their physical and mental abilities beyond normal#human potential through technological implants in#the future and you're even positive about the - ";
	text_short[8] [2] = "- potential medical benefits, but you're not quite#ready to replace your brain with a Furby computer#chip yet. Disappointing. Sad and... disappointing.";
	text_short[8] [3] = "";

	text_short[9] [0] = 2;
	text_short[9] [1] = "Ahh, you respect the time-honored sitcom format#but much prefer cartoons. You're still a kid,#you'll come to appreciate them as you grow more#mature.";
	text_short[9] [2] = "Your favorite cartoon is Goof Troop.";
	text_short[9] [3] = "";
	
#endregion
	

func show_hands():
	
	if not visible:
		modulate.a = 0.0
		#selection.modulate.a = 0.0
		#quiz_text.modulate.a = 0.0
		
		var tween := create_tween()
		tween.tween_callback( show )
		tween.tween_property( self, "modulate:a", 1.0, 0.5)
		tween.tween_interval( 1.5 )
		#tween.tween_property( selection, "modulate:a", 1.0, 0.5)
		#tween.parallel().tween_property( quiz_text, "modulate:a", 1.0, 0.5)
		await tween.finished
	pass

func selected_line( line_id : int):
	#Quest("playerCCLine" + string(question_id + 1), line_index);
	pass

func _process(delta):
	time_goes_on += delta
	s_cc_palm_hand_area.modulate.a = ( sin( time_goes_on * 5.0) + PI ) / TAU
