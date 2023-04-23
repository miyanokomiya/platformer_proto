extends CharacterBody2D
class_name EnemyBase

@export var flip_h: bool = false
@export var flip_v: bool = false


func _ready():
	if flip_h:
		turn_h()
	
	if flip_v:
		turn_v()


func turn_h():
	scale.x *= -1


func turn_v():
	scale.y *= -1
