extends Node2D

@export var noise : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.play()
	$Logo.hide()
	$By.hide()
	$arhi.hide()
	$elina.hide()
	$tia.hide()
	$topi.hide()
	
	await get_tree().create_timer(2.0).timeout
	$Logo.show()
	await get_tree().create_timer(3.0).timeout
	$By.show()
	$arhi.show()
	$elina.show()
	$tia.show()
	$topi.show()
	$ParticleBubbles.emitting = true
	await get_tree().create_timer(10.0).timeout
	get_tree().change_scene_to_file("res://scenes/game/main_level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
