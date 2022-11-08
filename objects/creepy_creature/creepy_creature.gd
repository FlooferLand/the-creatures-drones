extends Node3D

# Nodes
@onready var model := $Model 
@onready var audio := $Audio 

# Node methods
func _ready():
	Global.the_creature = self
	model.visible = false

# Methods
func start():
	model.visible = true
	model.position.y = -0.1
	model.get_node("AnimationPlayer").playback_speed = 1.1
	model.get_node("AnimationPlayer").play("CrawlUp")
	audio.play()
