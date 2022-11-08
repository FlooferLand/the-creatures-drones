extends Node3D

# Nodes
@onready var parent: Node3D = get_parent().get_parent()
@onready var model: Node3D = $"../Model"
@onready var funny_sprite: Sprite3D = $Sprite
@onready var funny_audio: AudioStreamPlayer3D = $AudioPlayer
@onready var funny_timer: Timer = $SwitchSprite

# Variable
var doing_the_ooga_booga := false
var STOP_OOGA_BOOGAING_ME_DURING_DEVELOPMENT := false

func _ready():
	funny_timer.timeout.connect(
		func():
			if funny_sprite.texture == TextureState.ooga_booga[0]:
				funny_sprite.texture = TextureState.ooga_booga[1]
			elif funny_sprite.texture == TextureState.ooga_booga[1]:
				funny_sprite.texture = TextureState.ooga_booga[0]
	)
	funny_audio.finished.connect(
		func():
			funny_sprite.visible = false
			funny_timer.stop()
			doing_the_ooga_booga = false
			model.visible = true
	)

func _physics_process(_delta):
	var usable = Util.player_get_usable()
	if usable.type == "enemy" and usable.object == get_parent():
		_on_player_looking(true)
	else:
		_on_player_looking(false)
	
func _on_player_looking(is_looking: bool):
	if not is_looking:
		return
	var ooga_booga_chance := randi_range(0, 330)
	if ooga_booga_chance == 13:
		OOGA_BOOGA()

func OOGA_BOOGA():
	if doing_the_ooga_booga or Global.times_oogaboogad > 1 or STOP_OOGA_BOOGAING_ME_DURING_DEVELOPMENT:
		return
	
	Global.times_oogaboogad += 1
	
	doing_the_ooga_booga = true
	funny_sprite.visible = true
	funny_audio.play()
	funny_timer.start()
	model.visible = false
	print("GET SPOOKED AHAHHAHAHAHHAHAH")
