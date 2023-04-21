extends CharacterBody2D

@onready var player_detect_area = $PlayerDetectArea
@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var hurtbox_component = $HurtboxComponent

@export var h_flip: bool = false

var player_detected = false
var blocked = false
var died = false


func _ready():
	health_component.died.connect(on_died)
	if h_flip:
		scale.x *= -1


func start_block():
	if !player_detected || blocked:
		return
	
	start_invicible()
	animation_player.play("block")
	await get_tree().create_timer(2.0).timeout
	end_invicible()
	animation_player.play("unblock")
	await animation_player.animation_finished
	start_block()


func start_invicible():
	hurtbox_component.invincible = true
	blocked = true


func end_invicible():
	hurtbox_component.invincible = false
	blocked = false


func _on_player_detect_area_body_entered(_body):
	player_detected = true
	start_block()


func _on_player_detect_area_body_exited(_body):
	player_detected = false


func on_died():
	died = true
	animation_player.play("die")
