extends EnemyBase

@onready var player_detect_area = $PlayerDetectArea
@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var block_timer = $BlockTimer

var player_detected = false
var blocked = false
var died = false


func _ready():
	super._ready()
	health_component.died.connect(on_died)
	block_timer.timeout.connect(on_block_timer_timeout)


func start_block():
	if !player_detected || blocked:
		return
	
	start_invicible()
	animation_player.play("block")
	block_timer.start()


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


func _on_hurtbox_component_blocked(_hitbox_component):
	block_timer.start()


func on_block_timer_timeout():
	end_invicible()
	animation_player.play("unblock")
	await animation_player.animation_finished
	start_block()
