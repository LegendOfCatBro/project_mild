extends KinematicBody2D

export (int) var run_power = 300
export (int) var jump_power = -1000
export (int) var gravity = 50
export (int) var friction = 1.5
var velocity = Vector2()
var snap = Vector2(0,32)
onready var sprite = get_node("AnimatedSprite")

func get_input():
	if Input.is_action_pressed("right"):
		velocity.x += run_power
		sprite.flip_h = false
	if Input.is_action_pressed("left"):
		velocity.x -= run_power
		sprite.flip_h = true
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		sprite.play("walk")
	#this is shitty, optimize it later!!!
	if is_on_floor() and Input.is_action_pressed("up"):
		sprite.play("hops")
		velocity.y = jump_power
		snap = Vector2.ZERO
	else:
		velocity.y += gravity
		snap = Vector2(0,32)
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
	
	#why does it still process x movement even with the .y???
	velocity.y = move_and_slide_with_snap(velocity, snap, Vector2.UP, true).y 
	if abs(velocity.x) < 1 and abs(velocity.y) < 0.1 and sprite.is_playing():
		sprite.stop()
		sprite.set_frame(0)
