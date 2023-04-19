extends RayCast2D

@export var h_flip = false


func get_direction():
	if h_flip:
		return Vector2(-target_position.x, target_position.y).normalized()
	else:
		return target_position.normalized()


func get_angle():
	return target_position.angle()
