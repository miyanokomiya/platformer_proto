extends Area2D
class_name HitboxComponent

signal hit

@export var damage = 0


func get_damage() -> float:
	return damage
