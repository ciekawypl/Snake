extends Node2D

@export var tile_map : TileMap
@export var player : Player
@export var timer : Timer
var tail = preload("res://Tail/Tail.tscn")
var body = preload("res://Body/Body.tscn")
var food = preload("res://Food/Food.tscn")
var segments = []


func move_snake():
	player.move()
	var last_direction = tile_map.local_to_map(player.global_position)
	for segment in segments:
		segment.move(last_direction - tile_map.local_to_map(segment.global_position))
		last_direction = tile_map.local_to_map(segment.global_position)


func add_segment(new_position : Vector2):
	var new_segment
	if segments.is_empty():
		new_segment = body.instantiate()
		new_segment.global_position = new_position
		segments.append(new_segment)
		get_tree().root.add_child(new_segment)
		return
	
	new_segment = tail.instantiate()
	new_segment.global_position = segments.back().global_position
	segments.append(new_segment)
	get_tree().root.add_child(new_segment)


func spawn_food():
	var new_position : Vector2
	
	var busy = []
	for segment in segments:
		busy.append(tile_map.local_to_map(segment.global_position))
	
	while true:
		new_position = tile_map.map_to_local(Vector2(randi_range(1, 10), randi_range(1, 10)))
		if busy.has(tile_map.local_to_map(new_position)):
			continue
		break
	
	var new_food = food.instantiate()
	new_food.global_position = new_position
	get_tree().root.add_child(new_food)


func on_death():
	timer.stop()
	for segment in segments:
		segment.queue_free()
	player.queue_free()
	get_tree().get_first_node_in_group("Food").queue_free()
	$Label.show()
