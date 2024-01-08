class_name MissionController
extends Node

@export var player: Agent
@export var camera: CameraController

@export var navigation: Navigation
@export var geometry: GeometryController

func _ready() -> void:
	# DEBUG

	# Set control
	$ControlTest.player = player
	$ControlTest.camera = camera

	# Set camera
	camera.target = navigation.control_widget


	# Set navigation
	navigation.initialize_navigation()
	navigation.control_widget.reparent(player)
	navigation.control_widget.position = Vector3.ZERO

	# Set player
	player.global_position = navigation.spawn_point
	player.show()

