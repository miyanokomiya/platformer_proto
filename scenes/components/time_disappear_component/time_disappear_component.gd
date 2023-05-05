extends Node

signal timeout

@export var wait_time: float = 15.0
@export var sprite: Sprite2D
@export var auto_start: bool = false

@onready var timer = $Timer


func _ready():
	if auto_start:
		start()


func _physics_process(_delta):
	if timer.is_stopped():
		return
	
	var left = timer.time_left
	if left > 5.0:
		sprite.modulate.a = 1.0
	elif left > 4.0:
		sprite.modulate.a = cos_trip((left - 4.0) * TAU)
	elif left > 3.0:
		sprite.modulate.a = cos_trip((left - 3.0) * TAU)
	elif left > 2.0:
		sprite.modulate.a = cos_trip((left - 2.0) * TAU * 2)
	elif left > 1.0:
		sprite.modulate.a = cos_trip((left - 1) * TAU * 3)
	elif left > 0.0:
		sprite.modulate.a = cos_trip(left * TAU * 3)


func start():
	if wait_time > 0:
		timer.wait_time = wait_time
		timer.start()


func cos_trip(v: float) -> float:
	return (cos(v) + 1.0) / 2.0


func _on_timer_timeout():
	if !sprite:
		return

	sprite.modulate.a = 0
	timeout.emit()
