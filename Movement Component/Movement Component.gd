class_name MovementComponent extends Node2D

signal started_moving
signal finished_moving

signal hit_wall
signal collided_with(Vector2, Variant)

@export var anchor : Node2D

var tileMap : TileMap
var target_position : Vector2
var is_moving : bool

func _ready():
	tileMap = get_tree().get_first_node_in_group("Map")


func _physics_process(_delta):
	if is_moving == false:
		return
	
	anchor.global_position = anchor.global_position.move_toward(target_position, 1)
	
	if anchor.global_position == target_position:
		is_moving = false


func get_colliding_body(direction : Vector2):
	$RayCast2D.target_position = direction * 16
	$RayCast2D.force_raycast_update()
	return $RayCast2D.get_collider()


func can_move(direction : Vector2):
	var current_tile : Vector2 = tileMap.local_to_map(global_position)
	var target_tile = current_tile + direction
	var tile_data = tileMap.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		hit_wall.emit()
		return false
	
	$RayCast2D.target_position = direction * 16
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		collided_with.emit(direction, $RayCast2D.get_collider())
		return false
	
	return true

func move(direction : Vector2, check_if_can_move : bool = true):
	if is_moving:
		return
	
	var current_tile : Vector2 = tileMap.local_to_map(global_position)
	var target_tile = current_tile + direction
	
	if check_if_can_move:
		if not can_move(direction):
			return
	
	target_position = tileMap.map_to_local(target_tile)
	is_moving = true
