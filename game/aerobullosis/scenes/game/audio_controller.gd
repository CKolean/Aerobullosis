extends Node

@export var theme : AudioStreamPlayer
@export var danger : AudioStreamPlayer
@export var noise : AudioStreamPlayer

const NOISE_THRESHOLD = 400
const DANGER_THRESHOLD = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	danger.volume_db = linear_to_db(0)
	noise.volume_db = linear_to_db(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var red_amount = get_parent().red_amount
	var surface_distance = get_parent().get_surface_distance()
	
	
	if surface_distance < NOISE_THRESHOLD:
		noise.volume_db = linear_to_db((NOISE_THRESHOLD-surface_distance)/NOISE_THRESHOLD)
	else:
		noise.volume_db = linear_to_db(0)

	if red_amount >= DANGER_THRESHOLD:
		danger.volume_db = linear_to_db((red_amount-DANGER_THRESHOLD)/(1-DANGER_THRESHOLD))
		#theme.volume_db = linear_to_db(1-red_amount)
	else:
		danger.volume_db = linear_to_db(0)


func _on_theme_finished() -> void:
	theme.play()

func _on_danger_finished() -> void:
	danger.play()

func _on_noise_finished() -> void:
	noise.play()
