extends "res://parent_ai/creature.gd"

export var constant_roam = false
export var idle_length = 3 #secs of idle ani
export var move_length = 5 #secs of roam b4 idle

func _physics_process(delta):
	on_ledge = check_if_on_ledge()
	if(constant_roam):
		match_speed_to_direction()
		ani.play("MOVE")
	else:
		do_states(state)

func do_states(var current_state):
	if(current_state == states.IDLE):
		ani.play("IDLE")
		hSpeed = 0
		yield(get_tree().create_timer(idle_length),"timeout")
		state = states.MOVE
	elif(current_state == states.MOVE):
		match_speed_to_direction()
		ani.play("MOVE")
		yield(get_tree().create_timer(move_length),"timeout")
		state = states.IDLE
	elif(current_state == states.attack):
		atttack_player()
		ani.play("attack")
		
