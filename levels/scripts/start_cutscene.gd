extends Node3D

# Nodes
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var skip_indicator: Control = $UI/Control/SkipIndicator
@onready var skip_progress:  ProgressBar = $UI/Control/SkipIndicator/ProgressBar

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	for robot in $Hoard/Robots.get_children():
		robot.get_node("AnimationPlayer").play("Walk")
	anim_player.play("Main")
	anim_player.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(anim_name):
	if anim_name != "Main":
		return
	get_tree().change_scene_to_file("res://levels/game.tscn")

func _process(delta):
	if Input.is_action_pressed("cutscene_skip"):
		skip_indicator.visible = true
		skip_progress.value = lerp(skip_progress.value, 100.0, 3 * delta)
		if skip_progress.value > 95.0:
			_on_anim_finished("Main")
	else:
		skip_indicator.visible = false
		skip_progress.value = 0
