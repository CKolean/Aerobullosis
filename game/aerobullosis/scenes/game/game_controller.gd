extends Node2D

var red_amount = 0 # 0 - 255
var player_depth = 0
@onready var red_fade = get_node("RedFade")
@onready var player = get_node("Player")
var player_prev_position

# tätä isommaksi ja sukeltajantauti hidastuu
const RED_MULTIPLIER = 0.005
# tätä isommaksi ja palautuminen nopeutuu
const RECOVERY_MULTIPLIER = 0.4


# Called when the node enters the scene tree for the first time.
func _ready():
	player_prev_position = player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_depth_delta = player.position.y - player_prev_position.y
	player_prev_position = player.position
	# increase red amount if player moved up since last move
	if player_depth_delta < 0:
		red_amount += abs(player_depth_delta) * RED_MULTIPLIER
	# decrease red_amount by time elapsed
	if player_depth_delta >= 0:
		red_amount -= delta * RECOVERY_MULTIPLIER
	if red_amount < 0:
		red_amount = 0
	red_amount = clamp(red_amount, 0, 1)
	
	red_fade.modulate.a = red_amount
