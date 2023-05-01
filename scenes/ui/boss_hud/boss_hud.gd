extends CanvasLayer

signal health_filled

@export var health_component: HealthComponent

@onready var health_bar = %HealthBar
@onready var audio_stream_player = $AudioStreamPlayer


func _ready():
	if !health_component:
		return
	
	health_component.health_changed.connect(on_health_changed)
	health_bar.update_max_value(health_component.max_health)


func fill_health():
	await get_tree().create_timer(1.0).timeout
	var tween = create_tween()
	tween.tween_method(on_fill_tween, 0, health_component.current_health, health_component.current_health * 0.05)
	await tween.finished
	health_filled.emit()


func on_fill_tween(value: int):
	health_bar.update_value(value)
	audio_stream_player.play()


func on_health_changed():
	health_bar.update_value(health_component.current_health)
