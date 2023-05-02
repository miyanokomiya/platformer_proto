extends Node2D

signal died
signal exploded
signal activated

@export var fallen_block_scene: PackedScene

@onready var body_player = %BodyPlayer
@onready var hand_l_player = %HandLPlayer
@onready var hand_r_player = %HandRPlayer
@onready var hand_l = %HandL
@onready var punch_ray_cast = %PunchRayCast
@onready var hand_r = %HandR
@onready var block_drop_marker = %BlockDropMarker
@onready var right_hand_default_marker = %RightHandDefaultMarker
@onready var action_timer = %ActionTimer
@onready var right_hand_block_marker = %RightHandBlockMarker
@onready var block_detect_ray_cast = %BlockDetectRayCast
@onready var right_arm_root_marker = %RightArmRootMarker
@onready var left_arm_root_marker = %LeftArmRootMarker
@onready var right_wrist_marker = %RightWristMarker
@onready var left_wrist_marker = %LeftWristMarker
@onready var left_hand_default_marker = %LeftHandDefaultMarker
@onready var punch_collision = %PunchCollision
@onready var punch_after_effect = %PunchAfterEffect
@onready var boss_hud = $BossHUD
@onready var block_bottom_detect_ray_cast = %BlockBottomDetectRayCast
@onready var health_component = $HealthComponent
@onready var head_laser = %HeadLaser


enum STATE{DEACTIVATED, IDLE, DIED, HEAD_LASER, LEFT_PUNCH_READY, LEFT_PUNCH, LEFT_PUNCH_BACK, RIGHT_GRAB_READY, RIGHT_BLOCK_SEEK, RIGHT_BLOCK_DROP}
var current_state = STATE.DEACTIVATED

var MAX_PUNCH_RANGE = 280
var PUNCH_SPEED = 750
var current_punch_range = 0
var fallen_block: Node2D
var desparated = false
var DESPARETED_SPEED = 1.7
var speed_scale = 1.0


func _ready():
	hand_r.global_position = right_hand_default_marker.global_position
	hand_l.global_position = left_hand_default_marker.global_position
	boss_hud.visible = false

func _physics_process(delta):
	match current_state:
		STATE.DEACTIVATED:
			body_player.play("idle")
			hand_l_player.play("idle")
			hand_r_player.play("idle")
		STATE.IDLE:
			body_player.play("idle")
			hand_l_player.play("idle")
			hand_r_player.play("idle")
			if action_timer.is_stopped():
				action_timer.start()
		STATE.DIED:
			action_timer.stop()
			hand_l_player.pause()
			hand_r_player.pause()
		STATE.HEAD_LASER:
			hand_l_player.play("idle")
			hand_r_player.play("idle")
		STATE.LEFT_PUNCH_READY:
			pass
		STATE.LEFT_PUNCH:
			if current_punch_range < MAX_PUNCH_RANGE:
				current_punch_range += PUNCH_SPEED * delta
				hand_l.global_position.x -= PUNCH_SPEED * delta
			else:
				stop_left_punch()
				return

			if punch_ray_cast.is_colliding():
				var collider = punch_ray_cast.get_collider()
				if collider && collider.has_method("shove"):
					collider.shove(Vector2.LEFT * 500)
				stop_left_punch()
				return
		STATE.LEFT_PUNCH_BACK:
			pass
		STATE.RIGHT_GRAB_READY:
			pass
		STATE.RIGHT_BLOCK_SEEK:
			seek_drop_position(delta)
			keep_fallen_block()
		STATE.RIGHT_BLOCK_DROP:
			pass


func activate():
	boss_hud.visible = true
	boss_hud.fill_health()
	await boss_hud.health_filled
	current_state = STATE.IDLE
	activated.emit()
		


func shoot_head_laser():
	current_state = STATE.HEAD_LASER
	body_player.play("laser_ready")
	await body_player.animation_finished

	if current_state == STATE.DIED:
		return
	
	body_player.play("laser_shooting")
	await body_player.animation_finished

	if current_state == STATE.DIED:
		return
	
	body_player.play("laser_finished")
	await body_player.animation_finished

	if current_state == STATE.DIED:
		return
	
	current_state = STATE.IDLE


func left_punch():
	current_state = STATE.LEFT_PUNCH_READY
	current_punch_range = 0
	hand_l_player.play("punch")
	punch_after_effect.play()
	await hand_l_player.animation_finished

	if current_state == STATE.DIED:
		return
	
	hand_l_player.play("punching")
	current_state = STATE.LEFT_PUNCH


func left_punch_back():
	current_state = STATE.LEFT_PUNCH_BACK
	hand_l_player.play("punched")
	punch_after_effect.stop()
	var tween = create_tween()
	tween.tween_property(hand_l, "global_position", left_hand_default_marker.global_position, 1.2 / speed_scale).set_ease(Tween.EASE_IN).set_delay(1.0)
	await tween.finished

	if current_state == STATE.DIED:
		return
	
	current_state = STATE.IDLE


func stop_left_punch():
	left_punch_back()


func right_grab_block():
	current_state = STATE.RIGHT_GRAB_READY
	var tween = create_tween()
	tween.tween_property(hand_r, "global_position", right_hand_block_marker.global_position, 0.4 / speed_scale).set_ease(Tween.EASE_IN)
	await tween.finished

	if current_state == STATE.DIED:
		return
	
	hand_r_player.play("grab_block")
	await hand_r_player.animation_finished

	if current_state == STATE.DIED:
		return
	
	fallen_block = fallen_block_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("background_layer")
	if layer:
		layer.add_child(fallen_block)
	else:
		add_child(fallen_block)
	
	fallen_block.grab()
	keep_fallen_block()
	right_block_seek()


func keep_fallen_block():
	if !fallen_block:
		return
	
	fallen_block.global_position = hand_r.global_position + Vector2(5, 24)


func right_block_seek():
	current_state = STATE.RIGHT_BLOCK_SEEK
	await get_tree().create_timer(2.0 / speed_scale).timeout

	if current_state == STATE.DIED:
		return
	
	right_block_drop()


func seek_drop_position(delta: float):
	hand_r.global_position.y = lerp(hand_r.global_position.y, block_drop_marker.global_position.y, 2.0 * delta)
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if !player:
		return
	
	var to = max(block_drop_marker.global_position.x, player.global_position.x)
	hand_r.global_position.x = lerp(hand_r.global_position.x, to, 2.0 * delta)


func right_block_drop():
	current_state = STATE.RIGHT_BLOCK_DROP
	hand_r_player.play("release_block")
	await hand_r_player.animation_finished

	if current_state == STATE.DIED:
		return
	
	fallen_block.drop()
	fallen_block = null
	var tween = create_tween()
	tween.tween_property(hand_r, "global_position", right_hand_default_marker.global_position, 0.4 / speed_scale).set_ease(Tween.EASE_IN)
	await tween.finished

	if current_state == STATE.DIED:
		return
	
	current_state = STATE.IDLE


func speed_up():
	if desparated:
		return
	
	body_player.speed_scale = DESPARETED_SPEED
	hand_l_player.speed_scale = DESPARETED_SPEED
	hand_r_player.speed_scale = DESPARETED_SPEED
	speed_scale = DESPARETED_SPEED


func speed_default():
	body_player.speed_scale = 1.0
	hand_l_player.speed_scale = 1.0
	hand_r_player.speed_scale = 1.0
	speed_scale = 1.0
	desparated = false


func finish_explode():
	exploded.emit()
	queue_free()


func _on_punch_hitbox_hit():
	if current_state == STATE.LEFT_PUNCH:
		stop_left_punch()


func _on_action_timer_timeout():
	if current_state == STATE.DIED:
		return
	
	var v = RngManager.enemy_rng.randf()
	if block_detect_ray_cast.is_colliding():
		if v < 0.5:
			left_punch()
		else:
			shoot_head_laser()
	elif block_bottom_detect_ray_cast.is_colliding():
		if v < 0.3:
			right_grab_block()
		elif v < 0.8:
			shoot_head_laser()
		else:
			left_punch()
	else:
		if v < 0.8:
			right_grab_block()
		else:
			left_punch()


func _on_health_component_died():
	if fallen_block:
		fallen_block.queue_free()
	
	head_laser.stop()
	speed_default()
	punch_after_effect.stop()
	current_state = STATE.DIED
	body_player.play("died")
	died.emit()


func _on_health_component_damaged(_damage_value):
	if health_component.get_health_percent() <= 0.5:
		speed_up()
