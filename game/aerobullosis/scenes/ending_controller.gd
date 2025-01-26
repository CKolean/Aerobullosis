extends Node2D

@export var noise : AudioStreamPlayer
@export var seagull : AudioStreamPlayer

var game_scene = preload("res://scenes/game/main_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	game_scene = load("res://scenes/game/main_level.tscn")
	await get_tree().create_timer(0.5).timeout
	noise.play()
	seagull.play()
	await get_tree().create_timer(10.0).timeout
	queue_free()
	get_tree().root.add_child(game_scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
