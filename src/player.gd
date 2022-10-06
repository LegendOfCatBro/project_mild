extends KinematicBody2D

enum facing_direction{
	RIGHT,
	LEFT
}

export (int) var run_power = 300
export (int) var jump_power = -1000
export (int) var gravity = 50
export (int) var friction = 1.5

export(facing_direction) var current_direction = facing_direction.RIGHT 
var velocity = Vector2()
var snap = Vector2(0,32)

onready var ani : AnimatedSprite = $AnimatedSprite
onready var hitBox : CollisionShape2D = $CollisionShape2D

func get_input():
	if Input.is_action_pressed("dodge"):
		if (current_direction == facing_direction.RIGHT):
			hitBox.disabled = true 
	if Input.is_action_pressed("right"):
		velocity.x += run_power
		current_direction = facing_direction.RIGHT
		update_facing_direction()
	if Input.is_action_pressed("left"):
		velocity.x -= run_power
		current_direction = facing_direction.LEFT
		update_facing_direction()
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		ani.play("walk")
	#this is shitty, optimize it later!!!
	if is_on_floor() and Input.is_action_pressed("up"):
		velocity.y = jump_power
		snap = Vector2.ZERO
	else:
		velocity.y += gravity
		snap = Vector2(0,32)
	velocity.x /= friction
	
	#facing direction
func update_facing_direction():
	if(current_direction == facing_direction.RIGHT):
		ani.flip_h = false
	else:
		ani.flip_h = true
	""" This is the old way I did the flipping of the sprite
		I'm pretty sure it is less efficient so I commented it out but 
		I don't want to forget that we could use this in the future for detecting
		direction 
	var direction = int(velocity.direction_to(Vector2.LEFT).x)
	if direction > 0:
		get_node("Sprite").flip_h = true
	elif direction < 0:
		get_node("Sprite").flip_h = false
	"""
func _physics_process(delta):
	get_input()
	if abs(velocity.x) < 1 and ani.is_playing():
		ani.stop()
		ani.set_frame(0)
	#why does it still process x movement even with the .y???
	velocity.y = move_and_slide_with_snap(velocity, snap, Vector2.UP, true).y 
