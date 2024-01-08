class_name MissionController
extends Node

@export var player: Agent
@export var camera: CameraController

@export var navigation: Navigation
@export var geometry: GeometryController

func _ready() -> void:
	# DEBUG
	print(Vector3.RIGHT.rotated(Vector3.UP, PI / 2))

	# Set control
	$ControlTest.player = player
	$ControlTest.camera = camera

	# Set camera
	camera.target = player


	# Set navigation
	navigation.initialize_navigation()

	# Set player
	player.global_position = navigation.spawn_point
	player.show()

