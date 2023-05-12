extends Node2D

@export var flip_h: bool = false
@export var with_enemy: bool = true
@export var shot_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var attack_cooldown_timer = $AttackCooldownTimer
@onready var direction_anchor = $DirectionAnchor
@onready var in_marker = $InMarker

enum STATE{CLOSED, OPEN, CLOSE, ATTACK, OPENED, ENEMY_DIED, PLAYER_IN}
var current_state = STATE.CLOSED
var target_player: Player


func _ready():
	if flip_h:
		scale.x *= -1
	
	if !with_enemy:
		current_state = STATE.OPENED


func _physics_process(_delta):
	match current_state:
		STATE.CLOSED:
			animation_player.play("closed")
		STATE.OPEN:
			if with_enemy:
				animation_player.play("open_with_enemy")
			else:
				animation_player.play("open_empty")
		STATE.CLOSE:
			if with_enemy:
				animation_player.play("close_with_enemy")
			else:
				animation_player.play("close_empty")
		STATE.ATTACK:
			if with_enemy:
				animation_player.play("attack")
			else:
				current_state = STATE.OPENED
		STATE.ENEMY_DIED:
			animation_player.play("enemy_died")
		STATE.OPENED:
			animation_player.play("opened")
			if target_player:
				if Input.is_action_just_pressed("action_jump") && Input.is_action_pressed("move_down"):
					current_state = STATE.PLAYER_IN
					target_player.global_position = in_marker.global_position
					target_player.face_right(flip_h)
					target_player.switch_state("ground_in_trap")
					animation_player.play("close_empty")
					target_player.state_changed.connect(on_player_out, CONNECT_ONE_SHOT)
		STATE.PLAYER_IN:
			pass


func start_attack():
	if with_enemy && current_state == STATE.OPEN:
		current_state = STATE.ATTACK


func finish_attack():
	if current_state == STATE.ATTACK:
		current_state = STATE.CLOSE


func shoot():
	var from = direction_anchor.global_position
	var direction = direction_anchor.get_global_direction()
	var shot = shot_scene.instantiate() as Node2D
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	layer = layer if layer else self
	layer.add_child(shot)
	shot.shoot(from, direction)


func closed():
	current_state = STATE.CLOSED
	if with_enemy:
		attack_cooldown_timer.start()


func opened():
	current_state = STATE.OPENED


func on_player_out():
	current_state = STATE.OPEN


func _on_attack_cooldown_timer_timeout():
	if with_enemy && current_state == STATE.CLOSED:
		current_state = STATE.OPEN


func _on_health_component_died():
	if with_enemy:
		with_enemy = false
		current_state = STATE.ENEMY_DIED


func _on_enter_area_body_entered(body):
	if body is Player:
		target_player = body


func _on_enter_area_body_exited(body):
	if target_player == body:
		target_player = null
