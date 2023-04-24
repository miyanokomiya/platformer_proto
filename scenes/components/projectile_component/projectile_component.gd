extends Node2D
class_name ProjectimeComponent

@export var speed = 100

var direction = Vector2.RIGHT


func angled_shoot(actor: Node2D, angle: float):
	var next_direction = Vector2.from_angle(angle)
	
	if direction.x * next_direction.x >= 0:
		if direction.x >= 0:
			actor.rotation = angle
		else:
			actor.rotation = angle + PI
	else:
		actor.scale.x *= -1
		if direction.x >= 0:
			actor.rotation = angle + PI
		else:
			actor.rotation = angle
	
	direction = next_direction


func y_angled_shoot(actor: Node2D, y_angle: float):
	if direction.x < 0:
		y_angle = PI - y_angle
	
	angled_shoot(actor, y_angle)


func move(actor: Node2D, delta):
	actor.global_position += direction * speed * delta
