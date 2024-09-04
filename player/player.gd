class_name Player extends Node2D

signal player_died
signal food_eaten(Vector2)

@export var movement_component : MovementComponent

var direction : Vector2 = Vector2.RIGHT

func _process(delta):
	var last_direction = direction
	
	if Input.is_action_just_pressed("up"):
		direction = Vector2.UP
	elif Input.is_action_just_pressed("down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("right"):
		direction = Vector2.RIGHT
	
	if movement_component.get_colliding_body(direction) is Body:
		direction = last_direction


func move():
	movement_component.move(direction)


func manage_collisions(_dir : Vector2, body : Variant):
	if body is Food:
		movement_component.move(direction, false)
		food_eaten.emit(global_position)
		body.queue_free()
	
	if body is Tail:
		die()


func die():
	player_died.emit()
