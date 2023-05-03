extends EnemyBase

@export var bullet_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var item_drop_component = $ItemDropComponent
@onready var turret_direction = $TurretDirection
@onready var shot_cooltime = %ShotCooltime


enum STATE{IDLE, DIED, SHOOT_FAR, SHOOT_MIDDLE}
var current_state = STATE.IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shot_state_queue = UniqueQueue.new()
var shot_cooldown = false


func _ready():
	super._ready()
	health_component.died.connect(on_died)


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			animation_player.play("idle")
		STATE.DIED:
			animation_player.play("die")
		STATE.SHOOT_FAR:
			if !shot_cooldown:
				animation_player.play("shoot_far")
		STATE.SHOOT_MIDDLE:
			if !shot_cooldown:
				animation_player.play("shoot_middle")
	
	velocity.y += gravity * delta
	move_and_slide()


func shoot():
	var bullet = bullet_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	layer = layer if layer else self
	layer.add_child(bullet)
	
	bullet.speed = 320 if current_state == STATE.SHOOT_FAR else 250
	bullet.shoot(turret_direction.global_position, turret_direction.get_global_direction())
	
	shot_cooldown = true
	shot_cooltime.start()
	await shot_cooltime.timeout
	shot_cooldown = false


func check_shot_state():
	if current_state == STATE.DIED:
		return
	
	if shot_state_queue.queue.size() == 0:
		current_state = STATE.IDLE
	else:
		current_state = shot_state_queue.queue[-1]


func on_died():
	current_state = STATE.DIED
	item_drop_component.try_drop()


func _on_player_detect_area_far_body_entered(_body):
	if current_state != STATE.DIED:
		shot_state_queue.append(STATE.SHOOT_FAR)
		check_shot_state()


func _on_player_detect_area_far_body_exited(_body):
	shot_state_queue.remove(STATE.SHOOT_FAR)
	check_shot_state()


func _on_player_detect_area_middle_body_entered(_body):
	if current_state != STATE.DIED:
		shot_state_queue.append(STATE.SHOOT_MIDDLE)
		check_shot_state()


func _on_player_detect_area_middle_body_exited(_body):
	shot_state_queue.remove(STATE.SHOOT_MIDDLE)
	check_shot_state()
