class_name GameRoot
extends Node

enum GameSceneIndex {MAINMENU, SPACE}

var saved_scene_path = {
	GameSceneIndex.MAINMENU: "res://Nodes/MainMenu/MainMenu.tscn",
#	GameSceneIndex.SPACE: ""
}

var scenes = {}

func _ready():
	change_scene(GameSceneIndex.MAINMENU)

func change_scene(target_scene_index: int, keep_scene: = false, _msg := {}):
	var scene: GameScene
	
	#检查此场景是否已实例化
	if scenes.has(target_scene_index):
		scene = scenes[target_scene_index]
	else:
		
		#没有则实例化
		scene = load(saved_scene_path[target_scene_index]).instantiate()
		scene.root = self
		scenes[target_scene_index] = scene
	
	#遍历所有已添加场景
	for scene_index in scenes:
		var _scene = scenes[scene_index]
		if scene_index != target_scene_index and self.get_children().has(_scene):
			#call退出
			_scene.exit()
			self.remove_child(_scene)
			
			#如果此场景不需要保留，直接删除
			if !keep_scene:
				scenes.erase(scene_index)
				_scene.queue_free()
	
	#添加到树
	Global.current_gamescene = scene
	self.add_child(scene)
	#传递参数
	scene.enter(_msg)
