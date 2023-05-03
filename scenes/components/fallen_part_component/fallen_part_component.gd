extends Node2D

@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var fallen_part_scene: PackedScene


func spawn():
	var body = fallen_part_scene.instantiate() as RigidBody2D
	body.global_position = global_position
	var dup_collision_shape = collision_shape.duplicate() as CollisionShape2D
	dup_collision_shape.disabled = false
	body.add_child(dup_collision_shape)
	var dup_sprite = sprite.duplicate() as Sprite2D
	dup_sprite.modulate = Color.GRAY
	body.add_child(dup_sprite)

	var layer = get_tree().get_first_node_in_group("background_layer")
	layer = layer if layer else self
	layer.add_child(body)
	body.angular_velocity = randf_range(-TAU, TAU)
	body.apply_central_impulse(Vector2.UP * 200)
