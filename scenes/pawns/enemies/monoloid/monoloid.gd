extends EnemyBase

@export var bullet_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var item_drop_component = $ItemDropComponent
@onready var shot_cooltime = %ShotCooltime
@onready var shot_direction = $ShotDirection
@onready var jump_trigger_marker = $JumpTriggerMarker


enum STATE{IDLE, DIED, SHOOT, SHOOT_COOLDOWN, JUMP, AIR_SHOOT, LANDED}
var current_state = STATE.IDLE
var was_in_air = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target: CharacterBody2D


func _ready():
	super._ready()
	health_component.died.connect(on_died)


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			animation_player.play("idle")
		STATE.DIED:
			animation_player.play("die")
			return
		STATE.SHOOT:
			pass
		STATE.SHOOT_COOLDOWN:
			pass
		STATE.JUMP:
			check_land()
		STATE.AIR_SHOOT:
			check_land()
		STATE.LANDED:
			animation_player.play("landed")
	
	was_in_air = !is_on_floor()
	velocity.y += gravity * delta
	move_and_slide()


func try_attack():
	if current_state == STATE.DIED || !shot_cooltime.is_stopped():
		return
	
	if !target:
		current_state = STATE.IDLE
		return
	
	if shot_direction.get_global_direction().x * (target.global_position.x - global_position.x) < 0:
		turn_h()
	
	current_state = STATE.SHOOT
	animation_player.play("shoot")


func shoot():
	var bullet = bullet_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	layer = layer if layer else self
	layer.add_child(bullet)
	bullet.shoot(shot_direction.global_position, shot_direction.get_global_direction())


func attack_finished():
	shot_cooltime.start()


func jump():
	if current_state == STATE.DIED:
		return
	
	
	if shot_direction.get_global_direction().x * (target.global_position.x - global_position.x) < 0:
		turn_h()
	
	current_state = STATE.JUMP
	animation_player.play("jump")


func proc_jump():
	velocity.y -= 400


func try_air_attack():
	if current_state == STATE.DIED:
		return
	
	current_state = STATE.AIR_SHOOT
	animation_player.play("air_shoot")


func check_land():
	if !was_in_air || !is_on_floor():
		return
	
	if current_state != STATE.DIED:
		current_state = STATE.LANDED
		shot_cooltime.start()


func land_finished():
	if current_state != STATE.DIED:
		current_state = STATE.IDLE


func on_died():
	current_state = STATE.DIED
	item_drop_component.try_drop()


func _on_player_detect_area_body_entered(body):
	if current_state != STATE.DIED:
		target = body
		shot_cooltime.start()


func _on_player_detect_area_body_exited(_body):
	target = null
	if current_state != STATE.DIED:
		current_state = STATE.IDLE
		shot_cooltime.stop()


func _on_shot_cooltime_timeout():
	if current_state == STATE.DIED:
		return
	
	if target && target.global_position.y < jump_trigger_marker.global_position.y:
		jump()
	else:
		try_attack()
