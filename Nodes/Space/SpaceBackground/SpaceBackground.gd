extends Node3D

@onready var camera = $Camera3D

func _process(_delta):
	if is_instance_valid(Global.current_camera):
		camera.rotation = Global.current_camera.rotation
