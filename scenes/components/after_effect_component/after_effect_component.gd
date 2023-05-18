extends Node2D
class_name AfterEffectComponent

@export var sprite: Sprite2D
@export var lifetime: float = 0.3
@export var flip_h: bool = false
@export var direction_anchor: DirectionAnchor
@export var effect_color: Color = Color.WHITE
@export var effect_material: ShaderMaterial

@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func play(wait_time = 0.075):
	if timer.is_stopped() || timer.wait_time != wait_time:
		timer.wait_time = wait_time
		timer.start()


func stop():
	timer.stop()


func spawn_effect():
	if !sprite:
		return
	
	var effect = sprite.duplicate() as Sprite2D
	var layer = get_tree().get_first_node_in_group("background_layer")
	if !layer:
		return
	
	layer.add_child(effect)
	
	if flip_h:
		effect.flip_h = !effect.flip_h
	
	if direction_anchor && direction_anchor.get_global_direction().x < 0:
		effect.flip_h = !effect.flip_h
	
	effect.global_position = global_position
	effect.material = effect_material.duplicate()
	effect.material.set_shader_parameter("mix_weight", 1.0)
	effect.material.set_shader_parameter("color", effect_color)
	var tween = create_tween()
	tween.tween_method(on_effect_tween.bind(effect), 1.0, 0.0, lifetime).set_ease(Tween.EASE_OUT)
	tween.tween_callback(effect.queue_free)


func on_effect_tween(alpha: float, effect: Sprite2D):
	effect.material.set_shader_parameter("alpha", alpha)


func on_timer_timeout():
	spawn_effect()
