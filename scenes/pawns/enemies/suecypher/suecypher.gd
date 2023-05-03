extends EnemyBase

@export var bullet_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var item_drop_component = $ItemDropComponent
@onready var shot_cooltime = %ShotCooltime
@onready var turret_direction_l = $TurretDirectionL
@onready var turret_direction_r = $TurretDirectionR
@onready var turn_timer = %TurnTimer

@onready var patrol_marker_1 = %PatrolMarker1
@onready var patrol_marker_2 = %PatrolMarker2
@onready var patrol_position_1 = patrol_marker_1.global_position
@onready var patrol_position_2 = patrol_marker_2.global_position

enum STATE{IDLE, DIED, SHOOT}
var current_state = STATE.IDLE

var speed = 60
var shot_cooldown = false
var current_patrol_target: int = 1


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
			if !shot_cooldown:
				animation_player.play("shoot")
	
	apply_patrol_velocity(delta)
	move_and_slide()


func get_current_patrol_position() -> Vector2:
	if current_patrol_target == 1:
		return patrol_position_1
	else:
		return patrol_position_2


func apply_patrol_velocity(delta: float):
	if !turn_timer.is_stopped():
		velocity = velocity.lerp(Vector2.ZERO, delta * 3)
		return
	
	check_patrol_target()
	velocity = velocity.lerp((get_current_patrol_position() - global_position).normalized() * speed, delta)


func check_patrol_target():
	if get_current_patrol_position().distance_squared_to(global_position) > 10.0:
		return
	
	current_patrol_target = 2 if current_patrol_target == 1 else 1
	turn_timer.start()


func shoot():
	shoot_to(turret_direction_l)
	shoot_to(turret_direction_r)
	shot_cooldown = true
	shot_cooltime.start()
	await shot_cooltime.timeout
	shot_cooldown = false


func shoot_to(anchor: DirectionAnchor):
	var bullet = bullet_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	layer = layer if layer else self
	layer.add_child(bullet)
	
	bullet.speed = 320
	bullet.shoot(anchor.global_position, anchor.get_global_direction())


func on_died():
	current_state = STATE.DIED
	item_drop_component.try_drop()


func _on_player_detect_area_body_entered(_body):
	if current_state != STATE.DIED:
		current_state = STATE.SHOOT


func _on_player_detect_area_body_exited(_body):
	if current_state != STATE.DIED:
		current_state = STATE.IDLE
