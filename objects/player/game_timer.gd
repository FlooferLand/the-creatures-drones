extends Panel

# Nodes
@onready var timer: Timer = $Timer

@onready var label:    Label = $Label
@onready var progress: ProgressBar = $ProgressBar

# Node methods
func _ready():
	timer.timeout.connect(_timeout)

func _timeout():
	Global.time -= 0.1
	label.text = str(snapped(Global.time, 0.1)) + " seconds";
	progress.value = Global.time
	
	# Time over (bad ending)
	if Global.time <= 0.0:
		get_tree().change_scene_to_file("res://levels/time_game_over.tscn")
	
