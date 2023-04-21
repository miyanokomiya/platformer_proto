extends Area2D
class_name HitboxComponent

signal hit
signal blocked

@export var damage = 0
@export var oneshot: bool = false


func get_damage() -> float:
	return damage
