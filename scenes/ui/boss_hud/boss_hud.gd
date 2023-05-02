extends CanvasLayer

signal health_filled

@export var health_component: HealthComponent

@onready var health_bar = %HealthBar


func _ready():
	if !health_component:
		return
	
	health_component.health_changed.connect(on_health_changed)
	health_bar.update_max_value(health_component.max_health)


func fill_health():
	health_bar.fill(health_component.current_health)
	await health_bar.fill_finished
	health_filled.emit()


func on_health_changed():
	health_bar.update_value(health_component.current_health)
