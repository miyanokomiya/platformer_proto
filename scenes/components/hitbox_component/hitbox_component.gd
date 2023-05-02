extends Area2D
class_name HitboxComponent

signal hit
signal blocked
signal denied

signal broken

@export var damage = 0
@export var oneshot: bool = false
## The higher, the easier this hitbox passes through hurtboxes
@export var density: int = 0


func get_damage() -> float:
	return damage
