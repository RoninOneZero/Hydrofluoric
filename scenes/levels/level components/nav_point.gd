class_name NavPoint
extends Marker3D

# Special Flags
@export var spawn_point := false
@export var block_size := 2


func _ready() -> void:
	$MeshInstance3D.hide()

func highlight() -> void:
	show()
	$FloorMarker.show()

func highlight_off() ->void:
	$FloorMarker.hide()


## Possible to have this node just check every single point, and not just based on params
func get_connections() -> PackedVector3Array:
	var list: PackedVector3Array = [

		global_position + block_size * Vector3.FORWARD,
		global_position + Vector3(0, 1.0, -block_size),
		global_position + Vector3(0, 0.5, -block_size),
		global_position + Vector3(0, -1.0, -block_size),
		global_position + Vector3(0, -0.5, -block_size),

		global_position + block_size * Vector3.RIGHT,
		global_position + Vector3(block_size, 1.0, 0),
		global_position + Vector3(block_size, 0.5, 0),
		global_position + Vector3(block_size, -1.0, 0),
		global_position + Vector3(block_size, -0.5, 0),

		global_position + block_size * Vector3.BACK,
		global_position + Vector3(0, 1.0, block_size),
		global_position + Vector3(0, 0.5, block_size),
		global_position + Vector3(0, -1.0, block_size),
		global_position + Vector3(0, -0.5, block_size),
		
		global_position + block_size * Vector3.LEFT,
		global_position + Vector3(-block_size, 1.0, 0),
		global_position + Vector3(-block_size, 0.5, 0),
		global_position + Vector3(-block_size, -1.0, 0),
		global_position + Vector3(-block_size, -0.5, 0)
	]

	return list

