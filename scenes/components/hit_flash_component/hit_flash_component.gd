extends Node

@export var hurtbox_component: HurtboxComponent
@export var sprite: Sprite2D
@export var whiten_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready():
	hurtbox_component.hit.connect(on_hit)
	sprite.material = whiten_material


func on_hit(_hitbox_component: HitboxComponent):
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	sprite.material.set_shader_parameter("mix_weight", 1.0)
	hit_flash_tween = create_tween()
	
	var remained = get_flash_duration()
	while remained >= 0.2:
		remained -= 0.2
		hit_flash_tween.tween_property(sprite.material, "shader_parameter/mix_weight", 0.0, 0.1)
		hit_flash_tween.tween_property(sprite.material, "shader_parameter/mix_weight", 0.7, 0.1)
	
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/mix_weight", 0.0, remained)


func get_flash_duration() -> float:
	return max(hurtbox_component.invincible_time, 0.1)
