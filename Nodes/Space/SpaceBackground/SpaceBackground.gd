extends Node3D

@onready var camera = $Camera3D

#func _process(_delta):
#	if is_instance_valid(Global.current_camera):
#		camera.rotation = Global.current_camera.rotation


#地球半径6378.137km


var GM = 3.986004418 * pow(10, 14)  # 地球引力常数
var a = 7000.0 * pow(10, 3)  # 半长轴
var e = 0.001  # 偏心率
var i = deg_to_rad(10)  # 轨道倾角
var omega = deg_to_rad(0)  # 升交点赤经
var w = deg_to_rad(0)  # 近地点幅角

# 计算轨道周期（开普勒第三定律）
var T = 2 * PI * sqrt(pow(a, 3) / GM)

var time = 0.0 #秒
func _process(_delta):
	time += _delta * 100.0
	
	$SolarSystem/Earth.rotation.y = time / 86400.0 * 2.0 * PI
	
	# 计算真近点角
	var M = 2 * PI * time / T
	var E = M + e * sin(M)
	var nu = 2 * atan(sqrt((1+e)/(1-e)) * tan(E/2))

	# 计算卫星在轨道平面中的位置
	var r = a * (1 - pow(e, 2)) / (1 + e * cos(nu))
	var x_orbit = r * cos(nu)
	var y_orbit = r * sin(nu)

	# 计算卫星在地心坐标系中的位置
	var x_ecef = x_orbit * (cos(omega) * cos(w) - sin(omega) * sin(w) * cos(i)) - y_orbit * (cos(omega) * sin(w) + sin(omega) * cos(w) * cos(i))
	var y_ecef = x_orbit * (sin(omega) * cos(w) + cos(omega) * sin(w) * cos(i)) + y_orbit * (sin(omega) * sin(w) - cos(omega) * cos(w) * cos(i))
	var z_ecef = x_orbit * (sin(w) * sin(i)) + y_orbit * (cos(w) * sin(i))

	camera.position = Vector3(x_ecef, z_ecef, y_ecef) / 6378137.0 * 50.0
#	print("卫星在地心坐标系中的位置：")
#	print("X: ", x_ecef)
#	print("Y: ", y_ecef)
#	print("Z: ", z_ecef)

