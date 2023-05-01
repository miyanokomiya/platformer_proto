extends Node2D
class_name DirectionAnchor

@onready var to_marker = $ToMarker


func get_global_direction() -> Vector2:
	var v = to_marker.global_position - global_position
	return v.normalized()
