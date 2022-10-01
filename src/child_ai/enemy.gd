extends "res://parent_ai/creature.gd"

export var constant_roam = false
export var idle_length = 3 #secs of idle ani
export var move_length = 5 #secs of roam b4 idle

onready var attack_right : RayCast2D = $attack_right
onready var attack_left : RayCast2D = $attack_left
			
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
		attack_player()
		ani.play("MOVE")
		yield(get_tree().create_timer(move_length),"timeout")
		state = states.IDLE
	elif(current_state == states.attack):
		attack_player()
		ani.play("attack")
		
func attack_player():
	#spot player
	if attack_left.is_colliding():
		print("colliding left")
		state = states.attack
	if attack_right.is_colliding():
		print("colliding right")
		state = states.attack
	if (!attack_left.is_colliding() or !attack_right.is_colliding()):
		print("not colliding")
		
