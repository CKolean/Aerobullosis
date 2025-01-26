extends Area2D

var screen_size # Size of the game window.
var start_position
@export var start_rotation = 92
@export var absolute_player_depth_px: float = 0.0
@export var can_sink: bool = true
@onready var animation_tree : AnimationTree = get_node("PlayerSprite2D/AnimationPlayer/AnimationTree")

var rotation_limit = 15
var right_rotation = 0.005
var left_rotation = 0.005
# I dont know what to do with this number
var rotation_correction_strenght = 0.01
var right_strenght = 50
var left_strenght = 50
var up_strenght = 100
var sea_gravity = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#start_position = Vector2(screen_size[0]/2,(screen_size[1]-100))
	#position = start_position
	#global_rotation_degrees = start_rotation
	#turning bubbles on
	#$ParticleBubbles.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	absolute_player_depth_px = position.y
		#gravity
	if not Input.is_anything_pressed() and can_sink==true:
		velocity.y += sea_gravity
		animation_tree["parameters/conditions/sinking"] = true
		animation_tree["parameters/conditions/moving"] = false
	else:
		animation_tree["parameters/conditions/sinking"] = false
		animation_tree["parameters/conditions/moving"] = true
	
	if Input.is_action_pressed("move_right"):
		velocity.x += right_strenght
		velocity.y -= right_rotation
		velocity += velocity.rotated(right_strenght)
		animation_tree["parameters/conditions/start"] = true
		if not global_rotation_degrees > rotation_limit:
			rotation = rotation + right_rotation
	if Input.is_action_pressed("move_left"):
		velocity.x -= left_strenght
		velocity.y -= left_strenght
		velocity += velocity.rotated(left_strenght)
		animation_tree["parameters/conditions/start"] = true
		if not global_rotation_degrees <-rotation_limit:
			rotation = rotation - left_rotation
	if Input.is_action_pressed("move_up"):
		velocity.y -= up_strenght
		animation_tree["parameters/conditions/start"] = true
		if global_rotation_degrees >0:
			rotation = rotation_correction_strenght
		else:
			rotation = rotation_correction_strenght
	
	if Input.is_action_just_released("move_up"):
		$ParticleBubbles.restart()
		
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
