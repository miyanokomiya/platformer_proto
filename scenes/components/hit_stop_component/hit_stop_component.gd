extends Node

@export var hitbox_component: HitboxComponent
@export var duration: float = 0.05

@onready var timer = $Timer


func _ready():
	hitbox_component.hit.connect(on_hitbox_component_hit)
	hitbox_component.blocked.connect(on_hitbox_component_blocked)
	hitbox_component.denied.connect(on_hitbox_component_denied)


func start():
	if duration <= 0:
		return
	
	timer.wait_time = duration
	timer.start()
	get_tree().paused = true


func on_hitbox_component_hit():
	start()


func on_hitbox_component_blocked():
	start()


func on_hitbox_component_denied():
	start()


func _on_timer_timeout():
	get_tree().paused = false
