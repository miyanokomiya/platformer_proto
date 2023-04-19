extends Node
class_name HealthComponent

signal died
signal damaged(value: float)
signal healed(value: float)
signal health_changed

@export var max_health: float = 10

var current_health: float


func _ready():
	current_health = max_health


func damage(value: float):
	current_health = clamp(current_health - value, 0, max_health)
	damaged.emit(value)
	health_changed.emit()
	check_death()


func heal(value: float):
	current_health = clamp(current_health + value, 0, max_health)
	healed.emit(value)
	health_changed.emit()
	check_death()


func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)


func check_death():
	if is_died():
		died.emit()


func is_died() -> bool:
	return current_health == 0
