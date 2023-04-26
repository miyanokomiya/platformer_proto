extends EnemyBase

@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var block_timer = %BlockTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var blocked = false
var died = false

enum BODY_STATE{STAND, CROUCH, PROSTRATE}
var current_body_state = BODY_STATE.STAND


func _ready():
	super._ready()
	health_component.died.connect(on_died)


func _physics_process(delta):
	if died:
		return
	
	velocity.y += gravity * delta
	move_and_slide()


func on_died():
	died = true
	animation_player.play("die")


func _on_shot_detect_area_high_area_entered(_area):
	if died || !block_timer.is_stopped():
		return
	
	match current_body_state:
		BODY_STATE.CROUCH:
			animation_player.play("stand_up")
		BODY_STATE.PROSTRATE:
			animation_player.play("stand_up_from_bottom")
	
	current_body_state = BODY_STATE.STAND
	block_timer.start()


func _on_shot_detect_area_middle_area_entered(_area):
	if died || !block_timer.is_stopped():
		return
	
	match current_body_state:
		BODY_STATE.STAND:
			animation_player.play("crouch_down")
		BODY_STATE.PROSTRATE:
			animation_player.play("crouch_up")
	
	current_body_state = BODY_STATE.CROUCH
	block_timer.start()


func _on_shot_detect_area_low_area_entered(_area):
	if died || !block_timer.is_stopped():
		return
	
	match current_body_state:
		BODY_STATE.STAND:
			animation_player.play("prostrate_down_from_top")
		BODY_STATE.CROUCH:
			animation_player.play("prostrate_down")
	
	current_body_state = BODY_STATE.PROSTRATE
	block_timer.start()


func _on_shield_hurtbox_component_blocked(_hitbox_component):
	block_timer.start()
