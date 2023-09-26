class_name Vehicle
extends CharacterBody3D

@onready var camera_marker = $CameraMarker

@export var pos_ACCELERATION = 10 #加速时的加速度
@export var neg_ACCELERATION = -10 #减速时的加速度

@onready var plane_mesh = $Mesh

@onready var rotation_reference = $RotReference

@onready var animation_player = $AnimationPlayer

var spinning_speed = 0
@export var spinning_speed_max = 24

@export var vertical_rot_speed_max = 1
@export var vertical_rot_accel = 2
var vertical_rot_speed = 0

@export var horizontal_rot_speed_max = 1
@export var horizontal_rot_accel = 2
var horizontal_rot_speed = 0

@export var y_rot_speed_max = 0.2
@export var y_rot_accel = 1
var y_rot_speed = 0

var speed = 0 #当前速度

#在这里实现所有vehicle通用的物理逻辑，不需要区分玩家还是敌机
func _physics_process(delta: float) -> void:
	var dir = (transform.basis*Vector3(speed,0,0)).normalized()
	velocity = dir*speed      #根据当前的rotation计算速度。因为rotation不断变化，所以基本上计算速度都要考虑transform.basis
	
		
	# 自动回正
		
	vertical_rot_speed = move_toward(vertical_rot_speed,0,vertical_rot_accel * delta * 0.5)
	horizontal_rot_speed = move_toward(horizontal_rot_speed,0,horizontal_rot_accel * delta * 0.5)
	y_rot_speed = move_toward(y_rot_speed,0,y_rot_accel * delta * 0.5)
	
	rotate(global_position - $Left.global_position,vertical_rot_speed * delta)
	
	plane_mesh.rotation.z = - horizontal_rot_speed / 3
		
	rotate($Front.global_position - global_position,horizontal_rot_speed * delta)
	
	rotate($Up.global_position - global_position,y_rot_speed * delta)
	
	# 横向旋转机动
		
	plane_mesh.rotation.z -= rotation_reference.rotation.x

	velocity += ($Left.global_position - global_position) * spinning_speed
	
	spinning_speed = move_toward(spinning_speed,0,spinning_speed_max / 0.6 *delta)
	
	# 左右慢速旋转
	
	move_and_slide()
	
	

func spin_left():
	if not animation_player.is_playing():
		animation_player.play("SpinL")
		spinning_speed = spinning_speed_max
		
func spin_right():
	if not animation_player.is_playing():
		animation_player.play("SpinR")
		spinning_speed = -spinning_speed_max
		
func accelerate(delta):
	speed += pos_ACCELERATION * delta;
	
func deaccelerate(delta):
	speed += neg_ACCELERATION * delta
	
func lift(delta):
	vertical_rot_speed += vertical_rot_accel * delta * 1.5
	if abs(vertical_rot_speed) > vertical_rot_speed_max:
		vertical_rot_speed = sign(vertical_rot_speed) * vertical_rot_speed_max
	
	
func drop(delta):
	vertical_rot_speed -= vertical_rot_accel * delta * 1.5
	if abs(vertical_rot_speed) > vertical_rot_speed_max:
		vertical_rot_speed = sign(vertical_rot_speed) * vertical_rot_speed_max
	
func rotate_left(delta):
	horizontal_rot_speed -= horizontal_rot_accel * delta * 1.5
	if abs(horizontal_rot_speed) > horizontal_rot_speed_max:
		horizontal_rot_speed = sign(horizontal_rot_speed) * horizontal_rot_speed_max

func rotate_right(delta):
	horizontal_rot_speed += horizontal_rot_accel * delta * 1.5
	if abs(horizontal_rot_speed) > horizontal_rot_speed_max:
		horizontal_rot_speed = sign(horizontal_rot_speed) * horizontal_rot_speed_max
		
func rotate_y_left(delta):
	y_rot_speed += y_rot_accel * delta * 1.5
	if abs(y_rot_speed) > y_rot_speed_max:
		y_rot_speed = sign(y_rot_speed) * y_rot_speed_max

func rotate_y_right(delta):
	y_rot_speed -= y_rot_accel * delta * 1.5
	if abs(y_rot_speed) > y_rot_speed_max:
		y_rot_speed = sign(y_rot_speed) * y_rot_speed_max
