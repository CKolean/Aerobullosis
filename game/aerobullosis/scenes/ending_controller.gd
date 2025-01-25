extends Node2D

@export var noise : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.5).timeout
	noise.play()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/game/main_level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
