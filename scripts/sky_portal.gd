extends Node3D

@onready var spinny: SpotLight3D = $spinny

func _process(delta):
	spinny.rotation.y += 0.1 * delta
	spinny.light_energy = lerp(spinny.light_energy, randf_range(25, 300), 3 * delta)
