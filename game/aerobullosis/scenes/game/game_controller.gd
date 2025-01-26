extends Node2D

var red_amount = RED_AMOUNT_MIN
var death_counter = 0
var player_depth = 0
@onready var red_fade = get_node("RedFade")
@onready var player = get_node("Player")
@onready var camera = get_node("Camera2D")
@onready var audio_controller = get_node("AudioController")
@onready var tutorial : AnimationTree = get_node("TutorialArrows/AnimationPlayer/AnimationTree")
@onready var black_screen : AnimationTree = get_node("Camera2D/BlackScreen/AnimationPlayer/AnimationTree")
@onready var red_screen : AnimationTree = get_node("Camera2D/RedScreen/AnimationPlayer/AnimationTree")
@onready var air_text = get_node("Camera2D/AirText")
@onready var air_animation : AnimationTree = get_node("Camera2D/AirText/AnimationPlayer/AnimationTree")
var player_prev_position
var tutorial_active = false
var air_amount = 10

var this_scene = preload("res://scenes/game/main_level.tscn")
var ending_scene = preload('res://scenes/ending.tscn')

var state_game_over = false

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
# kohta missä vajoaminen loppuu
const PLAYER_STOPS_SINKING = -20

# Called when the node enters the scene tree for the first time.
func _ready():
	state_game_over = false
	player_prev_position = player.position
	await get_tree().create_timer(1.0).timeout
	red_screen["parameters/conditions/fade_out"] = true
	red_screen["parameters/conditions/fade_in"] = false
	start_tutorial()

func get_surface_distance():
	return abs(SURFACE_Y - player.position.y)
	
func start_tutorial():
	await get_tree().create_timer(2.0).timeout
	tutorial["parameters/conditions/fade_in"] = true
	tutorial_active = true
	
func stop_tutorial():
	tutorial_active = false
	tutorial["parameters/conditions/fade_in"] = false
	tutorial["parameters/conditions/fade_out"] = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state_game_over:
		return
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
		
	camera.position = player.position
	
	if player.position.y <= -205 and tutorial_active:
		stop_tutorial()
	
	if player.position.y <= SURFACE_Y:
		game_completed()
	
	if player.position.y >= PLAYER_STOPS_SINKING:
		player.can_sink = false
	else:
		player.can_sink = true
	
func game_over():
	print('game_over')
	state_game_over = true
	audio_controller.silence_theme()
	red_screen["parameters/conditions/fade_out"] = false
	red_screen["parameters/conditions/fade_in"] = true
	await get_tree().create_timer(5.0).timeout
	queue_free()
	get_tree().root.add_child(this_scene.instantiate())
	
func game_over_air():
	print('game over air')
	state_game_over = true
	audio_controller.silence_danger()
	black_screen["parameters/conditions/fade_out"] = false
	black_screen["parameters/conditions/fade_in"] = true
	await get_tree().create_timer(5.0).timeout
	queue_free()
	get_tree().root.add_child(this_scene.instantiate())

func game_completed():
	print("won the game")
	queue_free()
	get_tree().root.add_child(ending_scene.instantiate())

func _on_player_lose_air():
	air_amount -= 1
	air_text.text = str(air_amount)
	air_animation["parameters/conditions/active"] = true
	await get_tree().create_timer(0.5).timeout
	air_animation["parameters/conditions/active"] = false
	
	if air_amount <= 0:
		game_over_air()

func is_game_over():
	return state_game_over
