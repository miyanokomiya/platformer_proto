extends Node2D

@export var floating_log_scene: PackedScene
@export var duration: float = 3.0
@export var delay: float = 0.0
@export var log_lifetime: float = 20.0
@export var log_speed: float = 20.0
## Used to spawn initial logs
@export var prespawn_count: int = 0
@export var disabled: bool = false

@onready var timer = $Timer
@onready var mock = $Mock


func _ready():
	remove_child(mock)
	mock.queue_free()
	timer.wait_time = duration
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
	
	for i in prespawn_count:
		Callable(prespawn).call_deferred(i)
	
	timer.start()


func spawn() -> CharacterBody2D:
	var floating_log = floating_log_scene.instantiate() as CharacterBody2D
	floating_log.global_position = global_position
	floating_log.lifetime = log_lifetime
	floating_log.speed = log_speed
	var layer = get_tree().get_first_node_in_group("background_layer")
	layer = layer if layer else self
	layer.add_child(floating_log)
	return floating_log


func prespawn(index: int):
	var floating_log = spawn()
	floating_log.global_position.y += index * log_speed * duration


func _on_timer_timeout():
	if disabled:
		timer.stop()
		return
	
	spawn()
