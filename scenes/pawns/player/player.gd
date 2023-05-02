extends CharacterBody2D
class_name Player

signal died

@onready var character_state_machine = $CharacterStateMachine
@onready var character_state_context = $CharacterStateContext
@onready var animation_player = $AnimationPlayer
@onready var close_floor_ray_cast = $CloseFloorRayCast
@onready var back_wall_ray_cast = $BackWallRayCast
@onready var front_wall_ray_cast = $FrontWallRayCast
@onready var after_effect_component = $AfterEffectComponent
@onready var sprite_2d = $Sprite2D
@onready var buster_texture_timer = $BusterTextureTimer
@onready var buster_direction = %BusterDirection
@onready var footstep_se = %FootstepSE
@onready var hurt_se = %HurtSE
@onready var charge_particles = %ChargeParticles
@onready var charge_particles_2 = %ChargeParticles2
@onready var charge_se = %ChargeSE
@onready var health_component = $HealthComponent

var default_texture = preload("res://assets/sprites/aria/aria.png")
var buster_texture = preload("res://assets/sprites/aria/aria_buster.png")

@export var flip_h = false
@export var small_shot: PackedScene
@export var middle_shot: PackedScene
@export var large_shot: PackedScene

func _ready():
	character_state_machine.state_changed.connect(on_state_changed)
	character_state_context.buster.connect(on_bustered)
	character_state_context.flipped.connect(on_flipped)
	buster_texture_timer.timeout.connect(on_buster_texture_timer_timeout)
	
	GlobalState.reset_player_health()
	GlobalState.bind_player_health_component(health_component)
	
	character_state_context.character = self
	character_state_context.animation_player = animation_player
	character_state_context.is_close_to_floor = is_close_to_floor
	character_state_context.is_close_to_front_wall = is_close_to_front_wall
	character_state_context.is_close_to_back_wall = is_close_to_back_wall
	character_state_context.after_effect_component = after_effect_component
	
	if flip_h:
		character_state_context.flip_character()
	
	switch_state("cutscene")


func teleport_in():
	switch_state("cutscene")
	animation_player.play("teleport_in")
	await animation_player.animation_finished
	switch_state("ground")


func instant_death():
	hurt_se.play()
	health_component.damage(10000)


func face_right(left = false):
	if left:
		if character_state_context.current_direction > 0:
			character_state_context.flip_character()
	else:
		if character_state_context.current_direction < 0:
			character_state_context.flip_character()


func is_close_to_floor() -> bool:
	return close_floor_ray_cast.is_colliding()


func is_close_to_front_wall() -> bool:
	return front_wall_ray_cast.is_colliding()


func is_close_to_back_wall() -> bool:
	return back_wall_ray_cast.is_colliding()


func play_footstep_se():
	footstep_se.play_random()


func get_current_state() -> CharacterState:
	return character_state_machine.current_state


func switch_state(state_name: String):
	character_state_machine.switch_state_by_name(state_name)


func on_state_changed():
	sprite_2d.texture = default_texture
	buster_texture_timer.stop()


func on_bustered(charge_level: int):
	sprite_2d.texture = buster_texture
	buster_texture_timer.start()
	
	var shot = small_shot.instantiate()
	if charge_level == 1:
		shot = middle_shot.instantiate()
	elif charge_level == 2:
		shot = large_shot.instantiate()
		
	get_tree().get_first_node_in_group("foreground_layer").add_child(shot)
	shot.shoot(buster_direction.global_position, buster_direction.get_direction())


func on_buster_texture_timer_timeout():
	sprite_2d.texture = default_texture


func on_flipped(h_flip: bool):
	buster_direction.h_flip = h_flip


func _on_hurtbox_component_hit(_hitbox_component):
	hurt_se.play()
	CameraManager.apply_noise_shake()
	character_state_machine.on_damage()




func _on_charge_component_charged(level):
	charge_se.pitch_scale = 1.18 + 0.5 * (level - 1)
	charge_se.play(80000)
	charge_particles.emitting = true
	charge_particles.visible = true
	if level == 1:
		charge_particles.restart()
	elif level == 2:
		charge_particles_2.emitting = true
		charge_particles_2.visible = true
		charge_particles_2.restart()


func _on_charge_component_released(_level):
	charge_se.stop()
	charge_particles.emitting = false
	charge_particles.visible = false
	charge_particles_2.emitting = false
	charge_particles_2.visible = false


func _on_health_component_died():
	switch_state("died")
	animation_player.play("died")
	await animation_player.animation_finished
	died.emit()
