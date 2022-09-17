extends KinematicBody2D

export (int) var run_power = 500
export (int) var jump_power = -1000
export (int) var gravity = 50
export (int) var friction = 1.5
var velocity = Vector2()

func get_input():
	
	if Input.is_action_pressed("right"):
		velocity.x += run_power
		get_node("Sprite").flip_h = false
	if Input.is_action_pressed("left"):
		velocity.x -= run_power
		get_node("Sprite").flip_h = true
	#make it so its a jump and not infinite moon jump
	if is_on_floor():
		if Input.is_action_pressed("up"):
			velocity.y = jump_power
		else:
			velocity.y = 0
	else:
		velocity.y += gravity
	velocity.x /= friction
	
	""" This is the old way I did the flipping of the sprite
		I'm pretty sure it is less efficient so I commented it out but 
		I don't want to forget that we could use this in the future for detecting
		direction 
	var direction = int(velocity.direction_to(Vector2.LEFT).x)
	if direction > 0:
		get_node("Sprite").flip_h = truea
	elif direction < 0:
		get_node("Sprite").flip_h = false
	"""
func _physics_process(delta):
	get_input()
	
	#added this second parameter so it knows which way is up when checking for floor
	velocity = move_and_slide(velocity, Vector2.UP) 
