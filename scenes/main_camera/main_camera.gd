extends Camera2D
class_name MainCamera

@export var target: Node2D

var original_limit = [0.0, 0.0, 0.0, 0.0]
var target_limit: Array[float] = []
var limit_id: int = -1
var target_position = Vector2.ZERO


func _ready():
	make_current()
	save_original_limit()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 5))


func set_bounds(id: int, center: Vector2, size: Vector2):
	limit_id = id
	var next_limit_top = center.y - size.y / 2
	var next_limit_right = center.x + size.x / 2
	var next_limit_bottom = center.y + size.y / 2
	var next_limit_left = center.x - size.x / 2
	
	target_limit = [next_limit_top, next_limit_right, next_limit_bottom, next_limit_left]


func save_original_limit():
	original_limit[0] = limit_top
	original_limit[1] = limit_right
	original_limit[2] = limit_bottom
	original_limit[3] = limit_left


func restore_original_limit():
	limit_top = original_limit[0]
	limit_right = original_limit[1]
	limit_bottom = original_limit[2]
	limit_left = original_limit[3]
	target_limit = []
	limit_id = -1


func acquire_target():
	if target:
		target_position = target.global_position
	
	if target_limit.size() != 4:
		return
	
	var viewport_rect = get_viewport_rect()
	
	var dx = max(target_limit[3] - (target_position.x - viewport_rect.size.x / 2), 0)
	dx += min(target_limit[1] - (target_position.x + viewport_rect.size.x / 2), 0)
	
	var dy = max(target_limit[0] - (target_position.y - viewport_rect.size.y / 2), 0)
	dy += min(target_limit[2] - (target_position.y + viewport_rect.size.y / 2), 0)
	
	target_position.x += dx
	target_position.y += dy
