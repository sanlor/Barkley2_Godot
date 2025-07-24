extends B2_EnvironInteractive

## Finding and Taking the Choco-mallows

#VARIABLES
	#chocoBballs
		#0 - haven't seen the cache
		#1 - seen the cache
		#2 - dribbled the ball
		#3 - cut open the ball
		#4 - taken the first crate
		#5 - taken the second crate
		#6 - taken the third crate
		
func execute_event_user_1() -> void:
	## Hide BBALL
	hide()
	
func execute_event_user_2() -> void:
	## Show BBALL
	show()
	
func execute_event_user_3() -> void:
	## Candy fill
	for i in 99:
		B2_Candy.gain_candy("Choco-mallows")
