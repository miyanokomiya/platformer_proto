extends Node

@export var hitbox_component: HitboxComponent
@export var hit_se: AudioStreamPlayer
@export var blocked_se: AudioStreamPlayer
@export var denied_se: AudioStreamPlayer


func _ready():
	hitbox_component.hit.connect(on_hitbox_component_hit)
	hitbox_component.blocked.connect(on_hitbox_component_blocked)
	hitbox_component.denied.connect(on_hitbox_component_denied)


func on_hitbox_component_hit():
	if hit_se:
		hit_se.play()


func on_hitbox_component_blocked():
	if blocked_se:
		blocked_se.play()


func on_hitbox_component_denied():
	if denied_se:
		denied_se.play()
