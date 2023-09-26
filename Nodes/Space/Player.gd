extends Node3D

#玩家控制的载具
@export var vehicle: Vehicle

@onready var camera = $Camera

@onready var crosshair = $Control/Crosshair
var crosshair_speed = 0.5
var crosshair_speed_max = 1000.0
var crosshair_velocity = Vector2.ZERO

func _ready():
	#要注册global的camera来更新背景
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.current_camera = camera


#在这里实现玩家的控制和摄像机
func _process(delta):
	if !is_instance_valid(vehicle):
		return
	
	# 准心控制
	
	var targ_pos = crosshair.position + crosshair_velocity * delta
	if targ_pos.distance_squared_to(Vector2(860,440)) > 250000:
		crosshair.position = (targ_pos - Vector2(860,440)).normalized() * 500 + Vector2(860,440)
		crosshair_velocity = Vector2.ZERO
	else:
		crosshair.position = targ_pos
	
	camera.global_transform = vehicle.camera_marker.global_transform


func _physics_process(delta):
	if !is_instance_valid(vehicle):
		return
	
	var speed_add = Input.get_axis("backward","forward");#加速度和减速
	if speed_add > 0: #加速
		vehicle.accelerate(delta)
		camera.fov = lerp(camera.fov,100.0,delta*5)
	elif speed_add < 0 and vehicle.speed > 0:#不知道能不能后退，此处先不允许后退
		vehicle.deaccelerate(delta)
		camera.fov = lerp(camera.fov,70.0,delta*5)
	else:
		camera.fov = lerp(camera.fov,80.0,delta*5)
		
	if Input.is_action_pressed("drop"):
		vehicle.drop(delta)
	if Input.is_action_pressed("lift"):
		vehicle.lift(delta)
		
	if Input.is_action_pressed("rotL"):
		vehicle.rotate_left(delta)
	if Input.is_action_pressed("rotR"):
		vehicle.rotate_right(delta)
		
	if Input.is_action_pressed("left"):
		vehicle.rotate_y_left(delta)
	if Input.is_action_pressed("right"):
		vehicle.rotate_y_right(delta)
		
	if Input.is_action_just_pressed("dodgeL"):
		vehicle.spin_left()
	if Input.is_action_just_pressed("dodgeR"):
		vehicle.spin_right()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var targ_vel = crosshair_velocity + event.relative * crosshair_speed
		if targ_vel.length() < crosshair_speed_max:
			crosshair_velocity = targ_vel
