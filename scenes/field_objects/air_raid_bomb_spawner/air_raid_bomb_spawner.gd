extends Node2D

enum DIRECTION{DOWN, LEFT, RIGHT}

@export var direction: DIRECTION = DIRECTION.DOWN
@export var interval: float = 5
@export var auto_start: bool = false
@export var range_marker: Node2D
@export var bomb_scene: PackedScene

@onready var shoot_timer = $ShootTimer
@onready var interval_timer = $IntervalTimer
@onready var mock_sprite = $MockSprite

var BOMB_INTERVAL = 30

var bomb_step = Vector2(BOMB_INTERVAL, 0)
var bomb_count = 5
var current_bomb_count = 0


func _ready():
	remove_child(mock_sprite)
	mock_sprite.queue_free()
	bomb_count = round(abs(range_marker.global_position.x - global_position.x) / BOMB_INTERVAL)
	bomb_step = (range_marker.global_position - global_position) / bomb_count
	
	if auto_start:
		start_shooting()


func start_shooting():
	interval_timer.wait_time = interval
	interval_timer.start()


func stop_shooting():
	interval_timer.stop()
	shoot_timer.stop()


func get_bomb_position() -> Vector2:
	return bomb_step * current_bomb_count


func get_bomb_direction() -> Vector2:
	match direction:
		DIRECTION.DOWN:
			return Vector2.DOWN
		DIRECTION.LEFT:
			return Vector2(-1, 1)
		DIRECTION.RIGHT:
			return Vector2(1, 1)
		_:
			return Vector2.DOWN


func shoot():
	var bomb = bomb_scene.instantiate() as Node2D
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	layer = layer if layer else self
	layer.add_child(bomb)
	var from = global_position + get_bomb_position()
	bomb.shoot(from, get_bomb_direction())
	
	current_bomb_count += 1
	if current_bomb_count < bomb_count:
		shoot_timer.start()


func _on_shoot_timer_timeout():
	shoot()


func _on_interval_timer_timeout():
	current_bomb_count = 0
	shoot_timer.start()
