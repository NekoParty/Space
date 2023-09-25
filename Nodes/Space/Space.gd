extends GameScene

#@onready var space_environment = preload("res://Nodes/Space/SpaceEnvironment/SpaceEnvironment.tscn").instantiate()

func setup():
	pass
#	#由于在编辑器预览environment会出错，直接在初始化时再将环境添加到树
#	self.add_child(space_environment)

func exit():
	Global.current_camera = null
