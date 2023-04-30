extends Node
class_name HealthComponent

signal died
signal damaged(damage_value: float)
signal healed(heal_value: float)
signal health_changed

@export var max_health: float = 10

var current_health: float


func _ready():
	current_health = max_health


func damage(value: float) -> float:
	var next = clamp(current_health - value, 0, max_health)
	var damage_value = current_health - next
	current_health = next
	damaged.emit(damage_value)
	health_changed.emit()
	check_death()
	return damage_value


func heal(value: float) -> float:
	var next = clamp(current_health + value, 0, max_health)
	var heal_value = next - current_health
	current_health = next
	healed.emit(heal_value)
	health_changed.emit()
	check_death()
	return heal_value


func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)


func check_death():
	if is_died():
		died.emit()


func is_died() -> bool:
	return current_health == 0
