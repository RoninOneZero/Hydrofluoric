class_name Navigation
extends Node

@onready var control_widget: ControlWidget = get_node("ControlWidget")

var spawn_point := Vector3.ZERO

var block_size: int = 2
var nav_markers: Array[NavPoint] = []
var nav_points: PackedVector3Array = []

var astar := AStar3D.new()
var nav_marker := preload("nav_marker.tscn")

var entities := {}

var has_control: bool = false
signal control_returned

func _ready() -> void:
	control_widget.hide()
	control_widget.block_size = block_size


	
func initialize_navigation() -> void:
	_initialize_astar()


## Return a path based on a location and distance.
func process_movement(origin: Vector3, distance: int) -> PackedVector3Array:
	# Get eligible points
	var active_points := get_points_in_range(origin, distance)


	# Highlight points
	for point in active_points:
		nav_markers[nav_points.find(point)].highlight()
	# Get a location from the widget
	control_widget.get_destination(origin, active_points)
	await control_widget.location_selected
	var destination = control_widget.position

	# Remove any markers
	get_tree().call_group("NavPoints", "highlight_off")

	return astar.get_point_path(nav_points.find(origin), nav_points.find(destination))


# could be more optimal
## Return a list of points that can be walked to from the origin point within given distance.
func get_points_in_range(location: Vector3, distance: int) -> PackedVector3Array:
	var point_list: PackedVector3Array = []
	# Poll points to see if navigation to location is possible
	for point in nav_points:
		var sample_path: = astar.get_point_path(nav_points.find(point), nav_points.find(location))
		# If the path exists, test its size.
		if !sample_path.is_empty():
			if sample_path.size() <= distance + 1:
				# Add only unique points to the point_list
				for item in sample_path:
					if !point_list.has(item):
						point_list.append(item)

	return point_list

## Generates nav points for A* pathfinding
func _initialize_astar():
	# Get navigation nodes
	nav_markers.assign(get_tree().get_nodes_in_group("NavPoints"))

	nav_points.resize(nav_markers.size())

	for node in nav_markers:
		# Check special flags
		if node.spawn_point: spawn_point = node.global_position
		# Record node positions and locations in astar
		var index = astar.get_available_point_id()
		nav_points[index] = node.global_position
		astar.add_point(index, nav_points[index])
		# Record connections
		var connections = node.get_connections()
		# Check if connections has points to connect
		# If so, check if positions in exists in astar
		# If so, connect the points
		if !connections.is_empty():
			for position in connections:
				if nav_points.has(position):
					astar.connect_points(index, nav_points.find(position))


func update_entities(node: Node3D, location: Vector3) -> void:
	entities[node] = location

