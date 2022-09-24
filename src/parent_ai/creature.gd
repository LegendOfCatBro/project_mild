extends KinematicBody2D
#def enums
enum states{
	IDLE,
	MOVE,
	attack,
	jump,
}
enum facing_direction{
	RIGHT,
	LEFT
}

export(facing_direction) var current_direction = facing_direction.RIGHT 
export var move_speed = 68 #how fast it moves

onready var right_ray : RayCast2D = $ray_right
onready var left_ray : RayCast2D = $ray_left
onready var ani : AnimatedSprite = $AnimatedSprite

var hSpeed = 0 #current velocity
var vSpeed = 0 #vertical velocity
var on_ledge : bool = false #ledge argument

var state = states.IDLE

var motion = Vector2.ZERO
var UP : Vector2 = Vector2(0,1)


func _ready():
	update_facing_direction()
	pass
	
func _physics_process(delta):
	do_physics(delta)
	
func check_if_on_ledge():
	if(!left_ray.is_colliding() or !right_ray.is_colliding()):
		return true
	else:
		return false
	
func do_physics(var delta):
		motion.y = vSpeed
		motion.x = hSpeed
		motion = move_and_slide(motion,UP)
	
func update_facing_direction():
	if(current_direction == facing_direction.RIGHT):
		ani.flip_h = false
	else:
		ani.flip_h = true
	
func match_speed_to_direction():
	if(current_direction == facing_direction.RIGHT):
		hSpeed = move_speed
	else:
		hSpeed = -move_speed
		
	#check wall bump or on ledge
	if(is_on_wall() or on_ledge):
		if(current_direction == facing_direction.RIGHT):
			position.x -= 10
			current_direction = facing_direction.LEFT
		else:
			position.x += 10
			current_direction = facing_direction.RIGHT
		update_facing_direction()
			
