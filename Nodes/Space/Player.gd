extends Node3D

#玩家控制的载具
@export var vehicle: Vehicle

@onready var camera = $Camera

func _ready():
	#要注册global的camera来更新背景
	Global.current_camera = camera


#在这里实现玩家的控制和摄像机
func _process(_delta):
	if !is_instance_valid(vehicle):
		return
	
	camera.global_transform = vehicle.camera_marker.global_transform


func _physics_process(_delta):
	if !is_instance_valid(vehicle):
		return
	
	pass
