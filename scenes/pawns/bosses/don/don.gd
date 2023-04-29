extends Node2D

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


enum STATE{IDLE, DIED, LEFT_PUNCH_READY, LEFT_PUNCH, LEFT_PUNCH_BACK, RIGHT_GRAB_READY, RIGHT_BLOCK_SEEK, RIGHT_BLOCK_DROP}
var current_state = STATE.IDLE

var MAX_PUNCH_RANGE = 260
var current_punch_range = 0
var fallen_block: Node2D


func _ready():
	right_grab_block()


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			body_player.play("idle")
			hand_l_player.play("idle")
			hand_r_player.play("idle")
			if action_timer.is_stopped():
				action_timer.start()
		STATE.DIED:
			body_player.pause()
			hand_l_player.pause()
			hand_r_player.pause()
		STATE.LEFT_PUNCH_READY:
			pass
		STATE.LEFT_PUNCH:
			if current_punch_range < MAX_PUNCH_RANGE:
				current_punch_range += 800 * delta
				hand_l.global_position.x -= 800 * delta
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


func left_punch():
	current_state = STATE.LEFT_PUNCH_READY
	current_punch_range = 0
	hand_l_player.play("punch")
	await hand_l_player.animation_finished
	current_state = STATE.LEFT_PUNCH


func left_punch_back():
	current_state = STATE.LEFT_PUNCH_BACK
	var tween = create_tween()
	tween.tween_property(hand_l, "position", Vector2(23, -15), 1.0).set_ease(Tween.EASE_IN).set_delay(1.0)
	await tween.finished
	current_state = STATE.IDLE


func stop_left_punch():
	left_punch_back()


func right_grab_block():
	current_state = STATE.RIGHT_GRAB_READY
	var tween = create_tween()
	tween.tween_property(hand_r, "global_position", right_hand_block_marker.global_position, 0.5).set_ease(Tween.EASE_IN)
	await tween.finished
	hand_r_player.play("grab_block")
	await hand_r_player.animation_finished
	
	fallen_block = fallen_block_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("background_layer")
	if layer:
		layer.add_child(fallen_block)
	else:
		add_child(fallen_block)
	
	fallen_block.grab()
	right_block_seek()


func keep_fallen_block():
	if !fallen_block:
		return
	
	fallen_block.global_position = hand_r.global_position + Vector2(5, 24)


func right_block_seek():
	current_state = STATE.RIGHT_BLOCK_SEEK
	await get_tree().create_timer(2.0).timeout
	right_block_drop()


func seek_drop_position(delta: float):
	hand_r.global_position.y = lerp(hand_r.global_position.y, block_drop_marker.global_position.y, delta)
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if !player:
		return
	
	hand_r.global_position.x = lerp(hand_r.global_position.x, player.global_position.x, 2 * delta)


func right_block_drop():
	current_state = STATE.RIGHT_BLOCK_DROP
	hand_r_player.play("release_block")
	await hand_r_player.animation_finished
	fallen_block.drop()
	fallen_block = null
	var tween = create_tween()
	tween.tween_property(hand_r, "global_position", right_hand_default_marker.global_position, 1.0).set_ease(Tween.EASE_IN)
	await tween.finished
	current_state = STATE.IDLE


func _on_punch_hitbox_hit():
	if current_state == STATE.LEFT_PUNCH:
		stop_left_punch()


func _on_action_timer_timeout():
	if block_detect_ray_cast.is_colliding():
		left_punch()
	elif randf() < 0.5:
		right_grab_block()
	else:
		left_punch()


func _on_health_component_died():
	queue_free()
