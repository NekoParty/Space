class_name Vehicle
extends CharacterBody3D

@onready var camera_marker = $CameraMarker

#在这里实现所有vehicle通用的物理逻辑，不需要区分玩家还是敌机
