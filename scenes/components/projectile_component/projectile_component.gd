extends Node2D
class_name ProjectimeComponent

@export var speed: float = 400.0
@export var gravity_rate: float = 0.0
@export var auto_rotation: bool = true

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.RIGHT
var is_first_frame = true


func angled_shoot(actor: Node2D, angle: float):
	var next_direction = Vector2.from_angle(angle)
	
	if direction.x * next_direction.x >= 0:
		if auto_rotation:
			if direction.x >= 0:
				actor.rotation = angle
			else:
				actor.rotation = angle + PI
	else:
		actor.scale.x *= -1
		if auto_rotation:
			if direction.x >= 0:
				actor.rotation = angle + PI
			else:
				actor.rotation = angle
	
	direction = next_direction
	is_first_frame = true


func y_angled_shoot(actor: Node2D, y_angle: float):
	if direction.x < 0:
		y_angle = PI - y_angle
	
	angled_shoot(actor, y_angle)


func move(actor: Node2D, delta):
	actor.global_position += direction * speed * delta


func move_and_slide(actor: CharacterBody2D, delta):
	if is_first_frame:
		actor.velocity = direction * speed
	
	actor.velocity.y += gravity * gravity_rate * delta
	actor.move_and_slide()
	is_first_frame = false
