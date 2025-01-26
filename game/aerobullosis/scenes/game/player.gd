extends Area2D

var screen_size # Size of the game window.
var start_position
@export var start_rotation = 92
@export var absolute_player_depth_px: float = 0.0
@export var can_sink: bool = true
@onready var animation_tree : AnimationTree = get_node("PlayerSprite2D/AnimationPlayer/AnimationTree")

var rotation_limit = 15
var rotation_correction_strenght = 0.01
var up_strenght = 100
var side_rotation = 30
var sea_gravity = 15
signal lose_air

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
func move_player(v,up_strenght,p_rotation,flip=false):
	
	v.y -= up_strenght
	if flip==true:
		#rotation = p_rotation
		v += v.rotated(p_rotation)
	else:
		#rotation = p_rotation
		v -= v.rotated(p_rotation)
	animation_tree["parameters/conditions/start"] = true
	print("velocity is ",v," strenght is ",up_strenght," rotation is ",p_rotation)
	return v
	#if global_rotation_degrees in range(rotation_limit,rotation_limit):
	#	print(global_rotation_degrees, "in range")
	#	rotation = rotation + strenght

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
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
		velocity = move_player(velocity,up_strenght,side_rotation)
	if Input.is_action_pressed("move_left"):
		velocity = move_player(velocity,up_strenght,side_rotation,true)
	if Input.is_action_pressed("move_up"):
		velocity.y -= up_strenght
		animation_tree["parameters/conditions/start"] = true
		if global_rotation_degrees >0:
			rotation = rotation_correction_strenght
		else:
			rotation = rotation_correction_strenght
	# not ideal way of doing this
	if Input.is_action_just_released("move_up"):
		emit_signal('lose_air')
		$ParticleBubbles.restart()
	if Input.is_action_just_released("move_left"):
		emit_signal('lose_air')
		$ParticleBubbles.restart()
	if Input.is_action_just_released("move_right"):
		emit_signal('lose_air')
		$ParticleBubbles.restart()
		
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
