extends Node3D

@onready var camera = $MainCamera
@export var player: CharacterBody3D
@onready var camera_ref = player.get_node("Camera")

@onready var post_processing_lens = $Lens

@onready var universe = $Universe
@onready var sun = $Universe/Atmosphere/SunMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.position = camera_ref.global_position
	camera.rotation = camera_ref.global_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = camera_ref.global_position
	camera.rotation = camera_ref.global_rotation
	camera.fov = camera_ref.fov
	var sun_position = camera.unproject_position(sun.global_position)
	post_processing_lens.material.set_shader_parameter("sun_position",sun_position)
