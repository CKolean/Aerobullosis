extends Node2D

var red_amount = RED_AMOUNT_MIN
var death_counter = 0
var player_depth = 0
@onready var red_fade = get_node("RedFade")
@onready var player = get_node("Player")
@onready var camera = get_node("Camera2D")
@onready var tutorial : AnimationTree = get_node("TutorialArrows/AnimationPlayer/AnimationTree")
var player_prev_position
var tutorial_active = false

# turvaväli alkuun
const RED_AMOUNT_MIN = -1.0
# tätä isommaksi ja sukeltajantauti hidastuu
const RED_MULTIPLIER = 0.005
# tätä isommaksi ja palautuminen nopeutuu
const RECOVERY_MULTIPLIER = 0.4
# aika ennenkuin kuolet kun on punaista
const DEATH_TIME = 3
# positio millä voittaa pelin
const SURFACE_Y = -3800

# Called when the node enters the scene tree for the first time.
func _ready():
	player_prev_position = player.position
	start_tutorial()

func get_surface_distance():
	return abs(SURFACE_Y - player.position.y)
	
func start_tutorial():
	await get_tree().create_timer(2.0).timeout
	tutorial_active = true
	print("should happen")
	tutorial["parameters/conditions/fade_in"] = true
	
func stop_tutorial():
	tutorial_active = false
	tutorial["parameters/conditions/fade_in"] = false
	tutorial["parameters/conditions/fade_out"] = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_depth_delta = player.position.y - player_prev_position.y
	player_prev_position = player.position
	# increase red amount if player moved up since last move
	if player_depth_delta < 0:
		red_amount += abs(player_depth_delta) * RED_MULTIPLIER
	# decrease red_amount by time elapsed
	if player_depth_delta >= 0:
		if red_amount > 0:
			red_amount -= delta * RECOVERY_MULTIPLIER
		else:
			red_amount -= delta * RECOVERY_MULTIPLIER * 2
	if red_amount < RED_AMOUNT_MIN:
		red_amount = RED_AMOUNT_MIN
	
	if red_amount >= 1:
		death_counter += delta
		if death_counter >= DEATH_TIME:
			game_over()
	else:
		death_counter = 0
		
	red_amount = clamp(red_amount, RED_AMOUNT_MIN, 1)
	red_fade.modulate.a = clamp(red_amount, 0, 1)
	
	if red_amount > 0:
		camera.zoom.x = 1.5 - red_amount * 0.2
		camera.zoom.y = 1.5 - red_amount * 0.2
	
	#print(player.position.y)
	
	camera.position = player.position
	
	if player.position.y <= -400 and tutorial_active:
		stop_tutorial()
	
	if player.position.y <= SURFACE_Y:
		game_completed()
	
func game_over():
	get_tree().reload_current_scene()

func game_completed():
	print("won the game")
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
