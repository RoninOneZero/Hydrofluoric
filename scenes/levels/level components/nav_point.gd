class_name NavPoint
extends Marker3D

# Special Flags
@export var spawn_point := false
@export var block_size := 2

enum BlockType {NONE = -1, FLOOR, ONE_UP, ONE_DOWN, HALF_UP, HALF_DOWN}

@export var terrain_type: BlockType = BlockType.FLOOR

@export var connection_north: BlockType
@export var connection_east: BlockType
@export var connection_south: BlockType
@export var connection_west: BlockType

var connections := [
    connection_north,
    connection_east,
    connection_south,
    connection_west
]

func _ready() -> void:
    hide()

func highlight() -> void:
    show()

func get_connections() -> PackedVector3Array:
    var list: PackedVector3Array = []

    match connection_north:
        BlockType.FLOOR: list.append(global_position + block_size * Vector3.FORWARD)

    match connection_east:
        BlockType.FLOOR: list.append(global_position + block_size * Vector3.RIGHT)
        BlockType.ONE_UP: list.append(global_position + Vector3(block_size, 1.0, 0))
        BlockType.HALF_UP: list.append(global_position + Vector3(block_size, 0.5, 0))

    match connection_south:
        BlockType.FLOOR: list.append(global_position + block_size * Vector3.BACK)
        
    match connection_west:
        BlockType.FLOOR: list.append(global_position + block_size * Vector3.LEFT)
        BlockType.ONE_DOWN: list.append(global_position + Vector3(-block_size, -1.0, 0))
        BlockType.HALF_DOWN: list.append(global_position + Vector3(-block_size, -0.5, 0))

    return list