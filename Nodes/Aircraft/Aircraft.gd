# Node里面的东西别他妈乱旋转和缩放他妈的

extends CharacterBody3D

var pos_ACCELERATION = 10;#加速时的加速度
var neg_ACCELERATION = -10;#减速时的加速度
var mouse_sensitivity = 70;#鼠标灵敏度

@onready var camera: Camera3D = $Camera

@onready var plane_mesh = $PlaneMesh
@onready var rotation_reference = $RotReference

@onready var animation_player = $AnimationPlayer

@onready var crosshair = $Control/Crosshair
var crosshair_speed = 0.5
var crosshair_speed_max = 1000.0
var crosshair_velocity = Vector2.ZERO

var spinning_speed = 0
var spinning_speed_max = 24

var vertical_rot_speed_max = 1
var vertical_rot_accel = 2
var vertical_rot_speed = 0

var horizontal_rot_speed_max = 1
var horizontal_rot_accel = 2
var horizontal_rot_speed = 0

var camera_distance = Vector3(-2,0.5,0)#摄像机的相对位置初始设定
var speed = 0#当前速度

var turing_time = 1

#飞机始终沿x轴移动，只改变rotation
#？认真的吗
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#隐藏鼠标
	pass

func _process(delta: float) -> void:
	# 移动准心部分
	var targ_pos = crosshair.position + crosshair_velocity * delta
	if targ_pos.distance_squared_to(Vector2(860,440)) > 250000:
		crosshair.position = (targ_pos - Vector2(860,440)).normalized() * 500 + Vector2(860,440)
		crosshair_velocity = Vector2.ZERO
	else:
		crosshair.position = targ_pos
	
	var dir = (transform.basis*Vector3(speed,0,0)).normalized()
	velocity = dir*speed      #根据当前的rotation计算速度。因为rotation不断变化，所以基本上计算速度都要考虑transform.basis
	
	var speed_add = Input.get_axis("backward","forward");#加速度和减速
	if speed_add>0:#加速
		speed += pos_ACCELERATION*delta;
		camera.fov = lerp(camera.fov,100.0,delta*5)
	elif speed_add<0 and speed>0:#不知道能不能后退，此处先不允许后退
		speed += neg_ACCELERATION*delta;
		camera.fov = lerp(camera.fov,70.0,delta*5)
	else:
		camera.fov = lerp(camera.fov,80.0,delta*5)
		
	# 旋转机身部分
		
	var angle_vert = Input.get_axis("drop","lift")
	vertical_rot_speed += angle_vert * vertical_rot_accel * delta
	if abs(vertical_rot_speed) > vertical_rot_speed_max:
		vertical_rot_speed = sign(vertical_rot_speed) * vertical_rot_speed_max
	if is_zero_approx(angle_vert):
		vertical_rot_speed = move_toward(vertical_rot_speed,0,vertical_rot_accel * delta)
	rotate(global_position - $Left.global_position,vertical_rot_speed * delta)
	
	var angle_hor = Input.get_axis("left","right")
	horizontal_rot_speed += angle_hor * horizontal_rot_accel * delta
	if abs(horizontal_rot_speed) > horizontal_rot_speed_max:
		horizontal_rot_speed = sign(horizontal_rot_speed) * horizontal_rot_speed_max
	
	plane_mesh.rotation.x = horizontal_rot_speed / 3
		
	if is_zero_approx(angle_hor):
		horizontal_rot_speed = move_toward(horizontal_rot_speed,0,horizontal_rot_accel * delta)
	rotate($Front.global_position - global_position,horizontal_rot_speed * delta)
	
	# 横向旋转机动
		
	plane_mesh.rotation.x += rotation_reference.rotation.x
	if not animation_player.is_playing():
		if Input.is_action_just_pressed("dodgeL"):
			animation_player.play("SpinL")
			spinning_speed = spinning_speed_max
		if Input.is_action_just_pressed("dodgeR"):
			animation_player.play("SpinR")
			spinning_speed = -spinning_speed_max
	
	velocity += ($Left.global_position - global_position) * spinning_speed
	
	spinning_speed = move_toward(spinning_speed,0,spinning_speed_max / 0.6 *delta)
	
	move_and_slide()
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var targ_vel = crosshair_velocity + event.relative * crosshair_speed
		if targ_vel.length() < crosshair_speed_max:
			crosshair_velocity = targ_vel
