class_name Body extends Area2D

@export var movement_component : MovementComponent

func move(direction : Vector2):
	movement_component.move(direction, false)
