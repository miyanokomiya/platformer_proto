extends Node2D

@export var with_enemy: bool = true
@export var shot_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var attack_cooldown_timer = $AttackCooldownTimer
@onready var direction_anchor = $DirectionAnchor

enum STATE{CLOSED, OPEN, CLOSE, ATTACK, OPENED, ENEMY_DIED}
var current_state = STATE.CLOSED


func _ready():
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
		STATE.OPENED:
			animation_player.play("opened")
		STATE.ENEMY_DIED:
			animation_player.play("enemy_died")


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


func _on_attack_cooldown_timer_timeout():
	if with_enemy && current_state == STATE.CLOSED:
		current_state = STATE.OPEN


func _on_health_component_died():
	if with_enemy:
		with_enemy = false
		current_state = STATE.ENEMY_DIED
