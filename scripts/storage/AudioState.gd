extends Node
#######################
# Audio State Manager #
#######################

# Variable declarations
var footsteps := {}
var door := {}
const enemy := { "angry": preload("res://audio/enemy_angry.wav") }

# Main init function
func _enter_tree():
	load_footsteps()
	load_door()

func play_once(audio: Node, clip: AudioStream):
	audio.stream = clip
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()

func play_random(audio: Node, clips: Array):
	play_once(audio, clips[randi_range(0, len(clips)-1)])

# Loading audio stuff
func load_footsteps():
	for ground_type in DirAccess.get_directories_at("res://audio/footsteps/"):
		footsteps[ground_type] = { "harsh": [], "soft": [] }
		
		for file in DirAccess.get_files_at("res://audio/footsteps/" + ground_type):
			if not file.ends_with(".wav"):
				continue
			
			var loaded = load("res://audio/footsteps/" + ground_type + "/" + file)
			if "harsh" not in file:
				footsteps[ground_type]["soft"].append(loaded)
			if "soft" not in file:
				footsteps[ground_type]["harsh"].append(loaded)

func load_door():
	door["open"]  = []
	door["close"] = []
	for file in DirAccess.get_files_at("res://audio/door/"):
		if not file.ends_with(".wav"):
			continue
		
		var loaded = load("res://audio/door/" + file)
		if "open" in file:
			door["open"].append(loaded)
		if "close" in file:
			door["close"].append(loaded)
