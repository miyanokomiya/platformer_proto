extends Node2D

enum DIRECTION{DOWN = 0, LEFT = 1, RIGHT = 2}

@export var direction: DIRECTION = DIRECTION.DOWN
@export var interval: float = 5
@export var auto_start: bool = false
@export var range_marker: Node2D
@export var bomb_scene: PackedScene
@export var bomb_prediction_scene: PackedScene

@onready var shoot_timer = $ShootTimer
@onready var interval_timer = $IntervalTimer
@onready var prediction_timer = $PredictionTimer
@onready var mock_sprite = $MockSprite

var BOMB_INTERVAL = 30

var bomb_step = Vector2(BOMB_INTERVAL, 0)
var bomb_count = 5
var current_bomb_count = 0


func _ready():
	remove_child(mock_sprite)
	mock_sprite.queue_free()
	bomb_count = floor(global_position.distance_to(range_marker.global_position) / BOMB_INTERVAL) + 1
	bomb_step = (range_marker.global_position - global_position) / bomb_count
	
	if auto_start:
		start_shooting()


func start_shooting():
	interval_timer.wait_time = interval
	interval_timer.start()
	prediction_timer.wait_time = max(0, interval - 3.5)
	if prediction_timer.wait_time > 0:
		prediction_timer.start()


func stop_shooting():
	interval_timer.stop()
	shoot_timer.stop()


func get_bomb_position(index: int) -> Vector2:
	return bomb_step * index


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
	var from = global_position + get_bomb_position(current_bomb_count)
	bomb.shoot(from, get_bomb_direction())
	
	current_bomb_count += 1
	if current_bomb_count < bomb_count:
		shoot_timer.start()
	else:
		start_shooting()


func spawn_predictions():
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	layer = layer if layer else self
	
	for i in bomb_count:
		var prediction = bomb_prediction_scene.instantiate() as Node2D
		prediction.direction = direction
		prediction.global_position = global_position + get_bomb_position(i)
		layer.add_child(prediction)


func _on_shoot_timer_timeout():
	shoot()


func _on_interval_timer_timeout():
	current_bomb_count = 0
	shoot_timer.start()


func _on_prediction_timer_timeout():
	spawn_predictions()
