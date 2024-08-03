extends Control

signal finished_quiz(bool)

@onready var quiz_text = $multiple_frame/quiz_text
@onready var option_1 = $multiple_frame/option1
@onready var option_2 = $multiple_frame/option2
@onready var option_3 = $multiple_frame/option3
@onready var option_4 = $multiple_frame/option4

@onready var selection = $multiple_frame/selection
@onready var selection_text = $multiple_frame/selection/selection_text


var text_choice := Array()
var answer := Array()
var boosts := Array()

var question_id := randi_range( 0, 43 )
var selected_response := 0 # 0 to 3

var answered_questions := -1

func _ready():
	option_1.pressed.connect( change_response.bind(0) )
	option_2.pressed.connect( change_response.bind(1) )
	option_3.pressed.connect( change_response.bind(2) )
	option_4.pressed.connect( change_response.bind(3) )
	
	hide() # start hidden
	
	text_choice.resize( 44 )
	answer.resize( 44 )
	for i in 44:
		answer[i] = PackedStringArray()
		answer[i].resize( 4 )
		
	boosts.resize( 44 )
	for i in 44:
		boosts[i] = PackedStringArray()
		boosts[i].resize( 4 )
	
	# 3 is important
	# 13 with the first answer kills you
	
	# notes: This is a huge mess to use the GLAMP system. its a horrible way to handle this. No way im porting this right now.
	#/// From choice add to glamp
	#// question_id = question
	#// answer_id = selection
	#var bst = boosts[question_id, answer_id];
	#Quest("tempCCG", Quest("tempCCG") + real(string_copy(bst, 2, 2)));
	#Quest("tempCCL", Quest("tempCCL") + real(string_copy(bst, 6, 2)));
	#Quest("tempCCA", Quest("tempCCA") + real(string_copy(bst, 10, 2)));
	#Quest("tempCCM", Quest("tempCCM") + real(string_copy(bst, 14, 2)));
	#Quest("tempCCP", Quest("tempCCP") + real(string_copy(bst, 18, 2)));
	
#region data
	
	text_choice[0] = "Your dad wants you to work on your layups but you'd rather...";
	text_choice[1] = "You've got a big assignment due tomorrow and you haven't even started.##Do you...";
	text_choice[2] = "You're playing b-ball with some friends when you hear the sound of police sirens approaching.##Do you...";
	text_choice[3] = 'The two dwarf brothers, Balbanes and Barbaneth, call your name to get your attention.##"' + str(B2_Playerdata.character_name) + ', come with me," Barbaneth cries out.##"No, come with me!" Balbanes shouts.##Who do you go with?';
	text_choice[4] = 'Your dad takes you to the vidcon store to pick up the new vidcon you wanted. "You can only have one, ' + str(B2_Playerdata.character_name) + '" your father tells you.##Which vidcon do you take?';
	text_choice[5] = "You and your father are at the circus. You have a deep fondness for...";
	text_choice[6] = "Your birthday's coming up and your dad wants to know what you want.##You tell him...";
	text_choice[7] = '"What did you think of those jazz CDs I lent you, son?"';
	text_choice[8] = 'It is fourth quarter, tie game, seconds left on the clock. You are surrounded on all sides and you do not have a clear shot, but you want the glory.##You see a teammate wide open under the basket.##"Pass me the rock!" he shouts.';
	text_choice[9] = "You got into a fight at school but don't want dad to know.##Do you...";
	text_choice[10] = "Sensei has been particularly harsh on your peers at the dojo today. He seems distracted and irritable, snapping at students for the most minor mistakes.##While demonstrating a new technique, Sensei sends one of your classmates flying with a powerful dojo kick to the gut. Everyone is quick to leave when class is over, but you stay behind to practice your spin dashes. You hear a strange noise coming from Sensei's office and decide to investigate. It's Sensei and he's sobbing! Do you...";
	text_choice[11] = '"I pledge allegiance to the flag of the United States of..."';
	text_choice[12] = 'TRUCK]_pump is talking bull puck about ~Hyberborea no Legends~ on GameCHAT again.##"It is beyond comprehension that anyone could find ANYTHING of worth in this inane drivel. ~Hyperborea no Legends~ and ALL derivative IPs (yes, even Sl3y[crescendo] RiSeR: Hyperborean Tactics) has the cultural and intellectual value of a saltine cracker. Heh, not to mention its fans."##You quaff a Game Fuel and don your fingerless posting gloves. It is time to knock this chump down a few pegs.';
	text_choice[13] = '"Just for the record, it is spelled..."';
	text_choice[14] = '"Alright, class is dismissed!"  You sigh in relief and bolt for the door. But suddenly, a weak, nasally voice from the back of the classroom -##"Mrs. Cooper, arent you going to collect the homework?" It is Clint, the teachers pet.##"Oh, thank you, Clint!" Mrs. Cooper puts her hand on your shoulder.##"Your homework, ' + str(B2_Playerdata.character_name) + '?"';
	text_choice[15] = "Life, Liberty and the pursuit of...";
	text_choice[16] = "Vidconcon, the biggest gaming and anime convention in Neo New York, is coming up soon.##Your friends thought it would be fun to cosplay and you decided to join them as...";
	text_choice[17] = '"' + "I'm sorry, son, but times are tough. We can't afford Choco Mallows. We're gonna have to get some off-brand breakfast cereal." + '"';
	text_choice[18] = "What's the first thing people notice about you?";
	text_choice[19] = "It's your favorite day of the year, Arbor Day. What kind of tree do you plant?";
	text_choice[20] = '"' + "You're looking tired, son. Drink this milk to grow stronger." + '"';
	text_choice[21] = "In what position on the b-ball court are you most comfortable?"
	text_choice[22] = '"' + "I'm sorry son," + '"' + " dad says sadly, " + '"' + "but we don't have enough muscle balm to last us the winter. You can have what little is left." + '"';
	text_choice[23] = '"' + "This corn better be shucked by the time I get back," + '"' + " says dad as he motions to a large mound of corn on the table." + '"' + " And if it's not," + '"' + " he adds ominously," + '"' + "you're grounded!" + '"';
	text_choice[24] = "It's your birthday and dad takes you to the music store to pick out a present. 'It's your special day and I want to give you the gift of music.##You may choose any instrument you'd like, but you must choose wisely.'";
	text_choice[25] = "Coach just doesn't seem to notice when you perform well today. She compliments other players for their layups when yours are better and didn't even see your dunk.##Is she ignoring you?";
	text_choice[26] = '"' + "You there," + '"' + " an old dwarf bellows at you. " + '"' + "What are you hiding in your slacks? Well, pipe up!" + '"';
	text_choice[27] = "Growing up, you always wanted to be like...";
	text_choice[28] = "You see the school bullies, the Bebop Boys, harassing a nerd in the locker room. " + '"' + "Gimme all your change, pipsqueek!" + '"' + " the ringleader grunts as he hefts the nerd up by the collar.##What do you do?";
	text_choice[29] = '"' + "Clispaeth, I know it's been a while. We don't talk like we used to, but I've always kept you in my heart. I haven't always been the most faithful follower, but I need you now more than ever. If you do this one thing for me, I'll pray every day.##I need you to..." + '"';
	text_choice[30] = "You've been saving up money for your first car for as long as you can remember. You're finally 16, you just got your driver's license and you're ready to drive.##What kind of car do you buy?";
	text_choice[31] = "It's your first date. You're nervous and awkward, but you know if you play it cool, you'll get a kiss by the end of the night.##Where do you take your date?";
	text_choice[32] = "Congratulations! The message you left on a Youtube video was rated the top comment!##What did it say?"
	text_choice[33] = "A dwarf with a breast pocket full of candy beckons you into an alley. He is holding Werther's Originals in his open palm.##Do you...";
	text_choice[34] = "Due to your living an empty and selfish existence in a past life, your choices for reincarnation are limited to lifeforms destined to go through life widely despised.##You have narrowed down your choices to:";
	text_choice[35] = "It's your mother's birthday!##Being a nefarious criminal, you feel compelled to steal your mother something special to show her you really value her contributions to your life of crime."
	text_choice[36] = "What's your idea of the perfect evening?";
	text_choice[37] = "It's been a tough day down at the plant! How do you unwind after this tough day?";
	text_choice[38] = "What's the secret to happiness?";
	text_choice[39] = "Your house is on fire!!! Think fast, what do you do!?!?";
	text_choice[40] = "You've just sold your soul to an evil demon.##It's too late to back out of it now, but on the plus side the demon has offered to gift you with infinite knowledge in a subject of your choice.";
	text_choice[41] = "What's your favorite eye color?";
	text_choice[42] = "A dutch, a dutch and a dutch walk into a bar. the dutch says to the other dutch:##CS:EIP 0180:00200862 ID d COD 00004734 SS:ESP 0188:00286c98 EAX 20200a00 EBX 00000020 ECX 00000010 EDX fffb0020 ESI 0026f714 EDI 0026DB38 EBP 000a0030 FLG 00000202 exception (0d) Crash address MAIN_ + 000378";
	text_choice[43] = "Wow, that was a good beer. But what's this? Now you have an empty glass bottle.##What do you do with it?";

	answer[0] [0] = "Play vidcons.";
	boosts[0] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[0] [1] = "Eat candy.";
	boosts[0] [1] = "G+1 L+0 A+0 M+0 P+0";
	answer[0] [2] = "Do homework.";
	boosts[0] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[0] [3] = "Pray.";
	boosts[0] [3] = "G+0 L+0 A+0 M+0 P+1";

	answer[1] [0] = "Pull an all-nighter to finish the work.";
	boosts[1] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[1] [1] = "Play vidcons all night.";
	boosts[1] [1] = "G+0 L+1 A+0 M+0 P+0";
	answer[1] [2] = "Call in sick tomorrow.";
	boosts[1] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[1] [3] = "Homework is BS! Homework is BS!";
	boosts[1] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[2] [0] = "Hide in an abandoned building.";
	boosts[2] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[2] [1] = "Battle all cops.";
	boosts[2] [1] = "G+1 L+0 A+0 M+0 P+0";
	answer[2] [2] = "Keep playing b-ball.";
	boosts[2] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[2] [3] = "Set anti-cop traps.";
	boosts[2] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[3] [0] = "Balbanes";
	boosts[3] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[3] [1] = "Barbaneth";
	boosts[3] [1] = "G+0 L+0 A+0 M+0 P+1";

	answer[4] [0] = "That crazy looking platformer - Horse Brappy";
	boosts[4] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[4] [1] = "The newest sports game - Touchdown Scholar 3";
	boosts[4] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[4] [2] = "That cool looking Japanese RPG - s.LAVE x_sever_x -[GAUNTLET crYsis]-";
	boosts[4] [2] = "G+0 L+0 A+0 M+1 P+0";
	answer[4] [3] = "A dry looking choose-your-own-adventure game - Ziggurat Electron School";
	boosts[4] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[5] [0] = "The willowy and daring trapeze artists.";
	boosts[5] [0] = "G+0 L+0 A+1 M+0 P+0";
	answer[5] [1] = "The enigmatic jugglers...";
	boosts[5] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[5] [2] = "Clowns galore!";
	boosts[5] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[5] [3] = "The madcap circus conductor.";
	boosts[5] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[6] [0] = "A new jock jam album to get you pumped up.";
	boosts[6] [0] = "G+0 L+0 A+0 M+1 P+0";
	answer[6] [1] = "A bonnet to keep me warm in the winter.";
	boosts[6] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[6] [2] = "That cool new ~Hyperborea no Legends~ vidcon that just came out - special edition WITH the Klaaust Mitsugiri wall scroll.";
	boosts[6] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[6] [3] = "Candy] [gum and chiclets.";
	boosts[6] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[7] [0] = "Avoiding hurting his feelings - " + '"' + "I liked em', dad." + '"';
	boosts[7] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[7] [1] = "Let him down gently - " + '"' + "Well, I thought they were interesting but I think I like jock jams more." + '"';
	boosts[7] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[7] [2] = "Try to change the subject - " + '"' + "Hey, um, wanna play some b-ball?" + '"';
	boosts[7] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[7] [3] = "Let him know how you really feel - " + '"' + "Get a grip, dad. I'm a jock jammer." + '"';
	boosts[7] [3] = "G+1 L+0 A+0 M+0 P+0";

	answer[8] [0] = "Toss him the ball, even though it means you won't score the game winning point.";
	boosts[8] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[8] [1] = "Take the shot even though you don't have a clean view.";
	boosts[8] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[8] [2] = "Juke these suckers into oblivion.";
	boosts[8] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[8] [3] = "The... Verboten Jam... ";
	boosts[8] [3] = "G+1 L+1 A+1 M+1 P+1";

	answer[9] [0] = "Come clean and tell dad what happened, hoping he'll understand.";
	boosts[9] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[9] [1] = "Embellish your story and ask dad for fighting tips.";
	boosts[9] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[9] [2] = "Cover your cuts in gum and hope dad doesn't notice.";
	boosts[9] [2] = "G+0 L+1 A+0 M+0 P+0";
	answer[9] [3] = "Say " + '"' + "bad dads say what" + '"' + " really fast to get your dad to say" + '"' + " what" + '"';
	boosts[9] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[10] [0] = "Take Sensei by surprise, strike from behind and become the new Sensei."
	boosts[10] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[10] [1] = "Challenge Sensei, knowing that he will be unable to defeat you in his moment of weakness. ";
	boosts[10] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[10] [2] = "Set high-level traps around the perimeter that Sensei will be unable to evade.";
	boosts[10] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[10] [3] = "Shout in his ear... then strike for the vitals!";
	boosts[10] [3] = "G+0 L+0 A+1 M+0 P+0";

	answer[11] [0] = "Vidcons."
	boosts[11] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[11] [1] = "Pocky."
	boosts[11] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[11] [2] = "Cartoons."
	boosts[11] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[11] [3] = "Toys, Candy and Gum."
	boosts[11] [3] = "G+0 L+1 A+0 M+0 P+0";

	answer[12] [0] = '"actually u do."';
	boosts[12] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[12] [1] = '"' + "say it don't spray it" + '"';
	boosts[12] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[12] [2] = '"' + "1. the grapics 2. the sound Fx by leggendary sound composser motonobu suzuki3. top 10 battle systems 4. need i say more? :badass::coolio:" + '"';
	boosts[12] [2] = "G+1 L+0 A+0 M+0 P+0";
	answer[12] [3] = '"' + "no flamming, no spamming." + '"';
	boosts[12] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[13] [0] = "Vid Con"
	boosts[13] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[13] [1] = "Konvid";
	boosts[13] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[13] [2] = "Vidcon";
	boosts[13] [2] = "G+1 L+1 A+1 M+1 P+1";
	answer[13] [3] = "Videocon";
	boosts[13] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[14] [0] = "Make up a lame excuse for why you didn't do your homework, even though you know she won't buy it."
	boosts[14] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[14] [1] = "Give her an old assignment and hope she doesn't notice.";
	boosts[14] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[14] [2] = "Confess that you didn't do it, face the punishment and beat up Clint after class.";
	boosts[14] [2] = "G+0 L+0 A+0 M+1 P+0";
	answer[14] [3] = '"' + "I left it in my locker, lemme go get it!" + '"' + " and make a run for it.";
	boosts[14] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[15] [0] = "Snacks."
	boosts[15] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[15] [1] = "New Jack Swing.";
	boosts[15] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[15] [2] = "Vidcons..";
	boosts[15] [2] = "G+1 L+1 A+1 M+1 P+1";
	answer[15] [3] = "Wall scrolls.";
	boosts[15] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[16] [0] = "Zalatar Aa'ethelwind, Elven Drake Slayer of the Order of Kyraxia from the Drakewind Chronicles";
	boosts[16] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[16] [1] = "GACKY, Sonic Traveler of the Aetherial Planes from Crystal Fantasia XI";
	boosts[16] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[16] [2] = "Klaaust Mitsugiri, aka " + '"' + "He Who Walks with Death." + '"' + " Pilot of the DEVIL_[blade] Mk. II mecha from ~Hyperborea no Legends~ ";
	boosts[16] [2] = "G+1 L+1 A+1 M+1 P+1";
	answer[16] [3] = "Xyaxis, Dual-Wielding Rogue Demon Killer Mercenary Ronin from the latest anime, Brutal Wizard[BRACKY]";
	boosts[16] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[17] [0] = '"' + "I understand, dad... I'm not angry." + '"';
	boosts[17] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[17] [1] = "Do odd jobs around town to get enough money for some Choco Mallows.";
	boosts[17] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[17] [2] = "Steal some Choco Mallows when dad's not around.";
	boosts[17] [2] = "G+0 L+0 A+1 M+0 P+0";
	answer[17] [3] = '"' + "I'm never gonna forgive you for this, dad." + '"';
	boosts[17] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[18] [0] = "Your luscious velvet lips.";
	boosts[18] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[18] [1] = "Your deep, empathetic eyes.";
	boosts[18] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[18] [2] = "Your powerful oaken biceps.";
	boosts[18] [2] = "G+0 L+0 A+0 M+1 P+0";
	answer[18] [3] = "Your wretched fedora.";
	boosts[18] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[19] [0] = "Sycamore tree";
	boosts[19] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[19] [1] = "Douglas fir";
	boosts[19] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[19] [2] = "Gum tree";
	boosts[19] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[19] [3] = "Arbor Day was concocted by corporations to sell bulbs.";
	boosts[19] [3] = "G+0 L+0 A+0 M+0 P+1";

	answer[20] [0] = "Take the milk... and throw it in his face!";
	boosts[20] [0] = "G+1 L+0 A+0 M+0 P+0";
	answer[20] [1] = "Submissively drink the milk.";
	boosts[20] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[20] [2] = "Pretend to drink the milk but dump it out when dad's not looking.";
	boosts[20] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[20] [3] = "You're just another pawn of Big Dairy.";
	boosts[20] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[21] [0] = "In the center, leading your team with boasts and hoots.";
	boosts[21] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[21] [1] = "On the sidelines as a coach, teaching your team valuable tactics.";
	boosts[21] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[21] [2] = "In the air, performing magnificent dunks.";
	boosts[21] [2] = "G+0 L+0 A+1 M+0 P+0";
	answer[21] [3] = "On the vanguard, pivoting around your foes.";
	boosts[21] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[22] [0] = "Rub the muscle balm on your sore calves.";
	boosts[22] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[22] [1] = "Split the muscle balm with dad, even if it means you don't get as much.";
	boosts[22] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[22] [2] = "Let dad have the muscle balm, knowing his muscles are just as sore as yours.";
	boosts[22] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[22] [3] = "Trick dad into eating it";
	boosts[22] [3] = "G+0 L+1 A+0 M+0 P+0";

	answer[23] [0] = "Resignedly shuck the corn, knowing full well you will soon be enjoying the kernels of your labor.";
	boosts[23] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[23] [1] = "Create corn husk dolls to distract your father.";
	boosts[23] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[23] [2] = "Get the gang together and have a corn shucking party!";
	boosts[23] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[23] [3] = "Run away from home.";
	boosts[23] [3] = "G+0 L+0 A+1 M+0 P+0";

	answer[24] [0] = "The noble trumpet, bellowing boldly in snow-capped mountains.";
	boosts[24] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[24] [1] = "The delicate flute, its soothing toots echoing through the misty forest.";
	boosts[24] [1] = "G+0 L+0 A+0 M+0 P+1";
	answer[24] [2] = "The mystical sitar, twanging an ancient raga from a land far away.";
	boosts[24] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[24] [3] = "Break every instrument in the store.";
	boosts[24] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[25] [0] = "Someday soon, YOU'LL be coach...";
	boosts[25] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[25] [1] = "Do jumping jacks to impress coach.";
	boosts[25] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[25] [2] = "Bulk up on carbs for more energy.";
	boosts[25] [2] = "G+0 L+0 A+0 M+1 P+0";
	answer[25] [3] = '"Ahem... Ahem..."';
	boosts[25] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[26] [0] = "Nuggets";
	boosts[26] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[26] [1] = "Cobs";
	boosts[26] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[26] [2] = "Nunchucks";
	boosts[26] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[26] [3] = '"' + "A sheriff's badge... you're under arrest." + '"';
	boosts[26] [3] = "G+1 L+0 A+0 M+0 P+0";

	answer[27] [0] = "Yasumi Matsuno";
	boosts[27] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[27] [1] = "Richard Garriott";
	boosts[27] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[27] [2] = "Akitoshi Kawazu.";
	boosts[27] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[27] [3] = "Lou Bega";
	boosts[27] [3] = "G+0 L+0 A+0 M+0 P+1";

	answer[28] [0] = "Join the Bebop Boys and teach the nerd a lesson.";
	boosts[28] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[28] [1] = "Stand up for the nerd and swoop attack the Bebop Boys.";
	boosts[28] [1] = "G+1 L+0 A+0 M+0 P+0";
	answer[28] [2] = "Distract the Bebop Boys with a juggling routine.";
	boosts[28] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[28] [3] = "The nerd... is me.";
	boosts[28] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[29] [0] = "Finish my homework for me.";
	boosts[29] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[29] [1] = "Make me stealthier than a puma.";
	boosts[29] [1] = "G+0 L+0 A+1 M+0 P+0";
	answer[29] [2] = "Give me chiclets and gum.";
	boosts[29] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[29] [3] = "Go scrooge yourself!";
	boosts[29] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[30] [0] = "An old and beat-up but reliable truck.";
	boosts[30] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[30] [1] = "A cool, red motorcycle to impress your friends.";
	boosts[30] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[30] [2] = "An affordable but nice sedan.";
	boosts[30] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[30] [3] = "Buy vidcons instead. Cars are for the ignorant.";
	boosts[30] [3] = "G+0 L+1 A+0 M+0 P+0";

	answer[31] [0] = "Catch a romantic comedy at the drive-in theater.";
	boosts[31] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[31] [1] = "Dinner at a romantic Italian place even though I don't have much money.";
	boosts[31] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[31] [2] = "The arcade to show off my mad vidcon skills.";
	boosts[31] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[31] [3] = "Church to pray.";
	boosts[31] [3] = "G+0 L+0 A+0 M+0 P+1";

	answer[32] [0] = "the fbi, nsa, cia and state department put chemtrails in the atmosphere to cause birth defects in illegal immigrants. google illuminati gangstalking and start stockpiling canned food,.";
	boosts[32] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[32] [1] = "thubs up if rayjay brought u here :))";
	boosts[32] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[32] [2] = "@dragonforce_atheist actually my IQ qualifies me as a genius on the Stanford-Binet scale, so how about you shut up.";
	boosts[32] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[32] [3] = "BULGARIA STRONGEST POLICEMAN,CRUSH THE HEAD,S OF CRIMINALS, FASTEST AND LOUDEST GUN'S OF ALL POLICE,BRUTALLY SUBDUE THE SCOFFLAW, NO MERCY FOR DELINQUENCY ,.DEATH AND AGONY UPON THE RASCAL.";
	boosts[32] [3] = "G+0 L+0 A+0 M+1 P+0";

	answer[33] [0] = "Follow the dwarf."
	boosts[33] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[33] [1] = "Snatch the candy.";
	boosts[33] [1] = "G+0 L+1 A+0 M+0 P+0";
	answer[33] [2] = "Run away.";
	boosts[33] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[33] [3] = "Spray the dwarf.";
	boosts[33] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[34] [0] = "Tapeworm"
	boosts[34] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[34] [1] = "Video Game Designer";
	boosts[34] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[34] [2] = "Middle School Physical Education Teacher";
	boosts[34] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[34] [3] = "Senator";
	boosts[34] [3] = "G+1 L+0 A+0 M+0 P+0";

	answer[35] [0] = "17 tons of gold bars";
	boosts[35] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[35] [1] = "A sterling silver lockpick kit";
	boosts[35] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[35] [2] = "Steal your mother's favorite sweater, sew someone else's name into it, give it back to her.";
	boosts[35] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[35] [3] = "Your next door neighbor's wooden leg";
	boosts[35] [3] = "G+0 L+0 A+0 M+1 P+0";

	answer[36] [0] = "Completing a conversation without any parties involved mentioning your goiter";
	boosts[36] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[36] [1] = "Receiving a phone call from someone other than a bill collector";
	boosts[36] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[36] [2] = "Renting a VHS tape that has already been rewound";
	boosts[36] [2] = "G+0 L+1 A+0 M+0 P+0";
	answer[36] [3] = "Making it over the barbed wire fence without getting bitten by rabid dogs";
	boosts[36] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[37] [0] = "Drink a beer(s)";
	boosts[37] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[37] [1] = "Watch the ball game";
	boosts[37] [1] = "G+0 L+0 A+1 M+0 P+0";
	answer[37] [2] = "Call your ex-wife and ask her to drop the lawsuit";
	boosts[37] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[37] [3] = "Hide in your panic room and hope the fires stop soon";
	boosts[37] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[38] [0] = "Visibly kiss all currency before handing it to the person at the register"; 
	boosts[38] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[38] [1] = "Never speak to anyone who owns a more expensive car than you do";
	boosts[38] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[38] [2] = "Take pictures of your bare feet in public restaurants";
	boosts[38] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[38] [3] = "Try not to defecate while being waterboarded";
	boosts[38] [3] = "G+0 L+0 A+0 M+0 P+1";

	answer[39] [0] = "Round up all lifeforms in the house and make your escape.";
	boosts[39] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[39] [1] = "Tell everybody in the house that you are performing a science experiment and that the house isn't on fire, despite what empirical evidence might otherwise suggest. Then quietly sneak out of the house.";
	boosts[39] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[39] [2] = "Let the fire engulf the house and collect the insurance money.";
	boosts[39] [2] = "G+1 L+0 A+0 M+0 P+0";
	answer[39] [3] = "I cannot leave the house. My guild will be very upset if they lose their backup sorcerer before they complete the Dark Tortoise Dungeon run";
	boosts[39] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[40] [0] = "Soul retrieval";
	boosts[40] [0] = "G+0 L+0 A+0 M+0 P+1";
	answer[40] [1] = "Fertility statistics of all lonely housewives in your area";
	boosts[40] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[40] [2] = "Gulag escape techniques";
	boosts[40] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[40] [3] = "Full epistemology of the " + '"' + "term cool ranch" + '"' + ".";
	boosts[40] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[41] [0] = "Blue";
	boosts[41] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[41] [1] = "Red";
	boosts[41] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[41] [2] = "Glass";
	boosts[41] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[41] [3] = "Spiny sonar tendrils";
	boosts[41] [3] = "G+0 L+1 A+0 M+0 P+0";

	answer[42] [0] = "Abort";
	boosts[42] [0] = "G+0 L+0 A+0 M+0 P+0";
	answer[42] [1] = "Retry";
	boosts[42] [1] = "G+1 L+0 A+0 M+0 P+0";
	answer[42] [2] = "Fail";
	boosts[42] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[42] [3] = "Contact customer support";
	boosts[42] [3] = "G+0 L+0 A+0 M+0 P+0";

	answer[43] [0] = "Find a recycling container and dispose of your refuse responsibly.";
	boosts[43] [0] = "G+1 L+0 A+0 M+0 P+0";
	answer[43] [1] = "Find a garbage can. Recycling is a scam.";
	boosts[43] [1] = "G+0 L+0 A+0 M+0 P+0";
	answer[43] [2] = "Smash the bottle on the bar and lunge for the throat of that tough-looking guy with the scars.";
	boosts[43] [2] = "G+0 L+0 A+0 M+0 P+0";
	answer[43] [3] = "Eat the entire bottle";
	boosts[43] [3] = "G+0 L+0 A+0 M+0 P+0";
	
#endregion
	


func show_quiz():
	setup_question()
	option_1.button_pressed = true
	change_response( 0 ) # default selection
	if question_id == 3:
		option_3.hide()
		option_4.hide()
	else:
		option_3.show()
		option_4.show()
		
	if not visible:
		modulate.a = 0.0
		selection.modulate.a = 0.0
		quiz_text.modulate.a = 0.0
		
		var tween := create_tween()
		tween.tween_callback( show )
		tween.tween_callback( selection.set.bind("disabled", true) )
		tween.tween_property( self, "modulate:a", 1.0, 0.5)
		tween.tween_interval( 1.5 )
		tween.tween_property( selection, "modulate:a", 1.0, 0.5)
		tween.parallel().tween_property( quiz_text, "modulate:a", 1.0, 0.5)
		tween.tween_callback( selection.set.bind("disabled", false) )
		await tween.finished
	
func setup_question():
	quiz_text.text = Text.pr( text_choice[question_id] )
	
func change_response( id : int ):
	selection_text.text = Text.pr( answer[ question_id ][ id ] )
	selected_response = id

func _on_selection_pressed():
	if question_id == 13 and selected_response == 0:
		# its VIDCON, not VID CON.
		## TODO kill the player with cc_death
		B2_Sound.play("sn_cc_death")
		B2_Music.play("mus_gameover", 0.1)
		finished_quiz.emit(true)
		queue_free()
		return
	
	B2_Playerdata.character_multiple[question_id] = selected_response;
	B2_Playerdata.Quest("playerCCMultiple" + str(question_id), var_to_str( selected_response + 1 ) );
	
	answered_questions += 1
	if answered_questions > 4:
		#Finished anwsering questions.
		var tween := create_tween()
		tween.tween_callback( selection.set.bind("disabled", true) )
		tween.tween_property( self, "modulate:a", 0.0, 0.5)
		tween.tween_callback( emit_signal.bind("finished_quiz") )
		tween.tween_callback( hide )
		return
	else:
		question_id += 1 + randi_range(0, 3)
		question_id = wrapi( question_id, 0, 43 )
		# question_id = 13 # debug
		
		var tween := create_tween()
		tween.tween_callback( selection.set.bind("disabled", true) )

		tween.tween_property( selection, "modulate:a", 0.0, 0.5)
		tween.parallel().tween_property( quiz_text, "modulate:a", 0.0, 0.5)
		tween.tween_callback( show_quiz )
		tween.tween_interval( 0.5 )
		tween.tween_property( selection, "modulate:a", 1.0, 0.5)
		tween.parallel().tween_property( quiz_text, "modulate:a", 1.0, 0.5)
		
		tween.tween_callback( selection.set.bind("disabled", false) )
	
