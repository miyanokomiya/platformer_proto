extends Camera2D
class_name MainCamera

@export var target: Node2D

var original_limit = [0.0, 0.0, 0.0, 0.0]
var target_position = Vector2.ZERO

var bounds_limits: Array[Dictionary] = []


func _ready():
	global_position = target_position
	make_current()
	save_original_limit()
	acquire_target()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 5))


func save_original_limit():
	original_limit[0] = limit_top
	original_limit[1] = limit_right
	original_limit[2] = limit_bottom
	original_limit[3] = limit_left


func set_bounds(id: int, center: Vector2, size: Vector2):
	var next_limit_top = center.y - size.y / 2
	var next_limit_right = center.x + size.x / 2
	var next_limit_bottom = center.y + size.y / 2
	var next_limit_left = center.x - size.x / 2
	
	bounds_limits = bounds_limits.filter(func(item): return item["id"] != id)
	bounds_limits.append({
		"id": id,
		"bounds": [next_limit_top, next_limit_right, next_limit_bottom, next_limit_left],
	})


func clear_limit(id: int):
	bounds_limits = bounds_limits.filter(func(item): return item["id"] != id)
	
	if bounds_limits.size() > 0:
		return
	
	limit_top = original_limit[0]
	limit_right = original_limit[1]
	limit_bottom = original_limit[2]
	limit_left = original_limit[3]


func acquire_target():
	if target:
		target_position = target.global_position + Vector2.UP * 12
	
	if bounds_limits.size() == 0:
		return
	
	var bounds = bounds_limits.back()["bounds"]
	var viewport_rect = get_viewport_rect()
	
	var dx = max(bounds[3] - (target_position.x - viewport_rect.size.x / 2), 0)
	dx += min(bounds[1] - (target_position.x + viewport_rect.size.x / 2), 0)
	
	var dy = max(bounds[0] - (target_position.y - viewport_rect.size.y / 2), 0)
	dy += min(bounds[2] - (target_position.y + viewport_rect.size.y / 2), 0)
	
	target_position.x += dx
	target_position.y += dy
