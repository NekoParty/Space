extends CharacterBody3D
var pos_ACCELERATION=10;#加速时的加速度
var neg_ACCELERATION=-10;#减速时的加速度
var mouse_sensitivity=70;#鼠标灵敏度
@onready var camera: Camera3D = $Camera3D
var camera_distance=Vector3(-2,0.5,0)#摄像机的相对位置初始设定
var speed=0#当前速度

var turing_time=1

#飞机始终沿x轴移动，只改变rotation
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#隐藏鼠标
	pass

func _process(delta: float) -> void:
	
	var dir=(transform.basis*Vector3(speed,0,0)).normalized()
	velocity=dir*speed#根据当前的rotation计算速度。因为rotation不断变化，所以基本上计算速度都要考虑transform.basis
	
	var speed_add=Input.get_axis("back","forward");#加速度和减速
	if speed_add>0:#加速
		speed+=pos_ACCELERATION*delta;
		camera.position=lerp(camera.position,2*camera_distance,delta)#改变摄像机，加速的镜头可以拉个广角
	elif speed_add<0 and speed>0:#不知道能不能后退，此处先不允许后退
		speed+=neg_ACCELERATION*delta;
		camera.position=lerp(camera.position,0.9*camera_distance,delta)#减速同理，摄像机向前一点点表示减速
	else:
		camera.position=lerp(camera.position,1*camera_distance,delta)#回到正常位置
		
		
	"""下面是按AD的部分，没想好怎么做
	if Input.is_action_pressed("left"):
		rotation_degrees.x+=5
	elif Input.is_action_pressed("right"):
		rotation_degrees.x-=5"""
		
	#turning(delta)#时刻让飞机自身保持水平，但是实际上放到星球里是不需要保持水平的
	
	camera.look_at(position,Vector3(0,1,0),false)#始终能看着飞机，可以试试注释这一行，是2两个视觉效果，但是明显注释掉更好一点
	
	move_and_slide()
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.relative.x>1:#控制左右转向的灵活性，不然能突然转向太突兀了
			rotation.y-=0.01
		elif event.relative.x<1:
			rotation.y+=0.01
			
		var deg=clamp(event.relative.x * 0.1,-10,10)#限制左右转时机身的摆角，不然会直接竖直
		rotation_degrees.x+=deg

		if event.relative.y>1:#上下转向，抬升和俯冲
			rotation_degrees.z-=1
		elif event.relative.y<-1:
			rotation_degrees.z+=1


func turning(delta):
	if rotation_degrees.x!=0:
		rotation_degrees.x=lerp(rotation_degrees.x,0.0,5*delta)
