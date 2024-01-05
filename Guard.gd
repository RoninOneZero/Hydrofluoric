extends Agent

@export var target_list: Array[Node3D] = []

## List of coordinates this unit can see, relative positions. Assumes forward facing.
var vision_profile: Array[Vector3] = [ 
	Vector3(0, 0, 0),
	Vector3(0, 0, -1),
	Vector3(0, 0, -2),
	Vector3(0, 0, -3),
	Vector3(0, 0, -4),
]

## Converts local vision profile into global 
func visibile_points() -> Array[Vector3]:
	var list: Array[Vector3] = []
	for point in vision_profile:
		list.append(point + global_position) #Use Vector3().rotated to properly adjust this
	
	return list


