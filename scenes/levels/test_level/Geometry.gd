class_name GeometryController
extends Node3D

@onready var block_gridmap: GridMap = get_node("Blocks")
@onready var ramp_gridmap: GridMap = get_node("Ramps")

const RAMP_SLOPE := 0.5236

var forward_basis = Basis(Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(1, 0, 0))
var back_basis = Basis(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0))
var left_basis = Basis(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, -1))
var right_basis = Basis(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1))

func get_block_list() -> Array[Node3D]:
	var new_list: Array[Node3D] = []

	for item in block_gridmap.get_meshes():
		if item is Transform3D:
			var node := Node3D.new()
			node.position = item.origin
			new_list.append(node)

	return new_list

func get_ramp_list() -> Array[Node3D]:
	var ramp_list: Array[Node3D] = []

	var whole_ramps: Array[Transform3D] = []
	for item in ramp_gridmap.get_meshes():
		if item is Transform3D:
			whole_ramps.append(item)
	# Slice ramp into 2 nodes
	for ramp in whole_ramps:
		var upper_ramp := Node3D.new()
		var lower_ramp := Node3D.new()

		upper_ramp.position = ramp.origin + Vector3(0, 0.5, 0)
		#var ramp_angle := Vector3.ZERO

		match ramp.basis:
			forward_basis: 
				lower_ramp.position = ramp.origin + Vector3(0, -0.5, 2)
				lower_ramp.rotation.x = RAMP_SLOPE
				upper_ramp.rotation.x = RAMP_SLOPE
			back_basis: 
				lower_ramp.position = ramp.origin + Vector3(0, -0.5, -2)
				lower_ramp.rotation.x = -RAMP_SLOPE
				upper_ramp.rotation.x = -RAMP_SLOPE
			right_basis: 
				lower_ramp.position = ramp.origin + Vector3(-2, -0.5, 0)
				lower_ramp.rotation.z = RAMP_SLOPE
				upper_ramp.rotation.z = RAMP_SLOPE
			left_basis: 
				lower_ramp.position = ramp.origin + Vector3(2, -0.5, 0)
				lower_ramp.rotation.z = -RAMP_SLOPE
				upper_ramp.rotation.z = -RAMP_SLOPE

		
		#upper_ramp.rotation = ramp_angle
		#lower_ramp.rotation = ramp_angle

		ramp_list.append(upper_ramp)
		ramp_list.append(lower_ramp)
	
	return ramp_list
		



	
