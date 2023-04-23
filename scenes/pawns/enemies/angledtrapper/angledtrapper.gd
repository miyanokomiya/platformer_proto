extends EnemyBase

@onready var player_detect_area = $PlayerDetectArea
@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var wall_bottom_detector = %WallBottomDetector
@onready var wall_top_detector = %WallTopDetector
@onready var ceil_detector = %CeilDetector
@onready var floor_detector = %FloorDetector

var player_detected = false
var broken = false
var breaking = false
var attacking = false
var walk_direction = 1
var turning = false


func _ready():
	super._ready()
	health_component.died.connect(on_died)


func _physics_process(delta):
	if breaking || attacking || turning:
		return
	
	if walk_direction == 1:
		if floor_detector.is_colliding() || !wall_bottom_detector.is_colliding():
			stop_and_turn()
			move_and_slide()
			return
	else:
		if ceil_detector.is_colliding() || !wall_top_detector.is_colliding():
			stop_and_turn()
			move_and_slide()
			return
	
	velocity.y = lerp(velocity.y, 20.0 * walk_direction, delta)
	animation_player.play("walk")
	move_and_slide()


func stop_and_turn():
	turning = true
	velocity.y = 0
	animation_player.play("idle")
	await get_tree().create_timer(2).timeout
	walk_direction *= -1
	turning = false


func start_attack():
	if broken:
		return
	
	attacking = true
	animation_player.play("attack")
	await animation_player.animation_finished
	attacking = false
	if player_detected:
		start_attack()


func start_invicible():
	hurtbox_component.invincible = true


func end_invicible():
	hurtbox_component.invincible = false


func _on_player_detect_area_body_entered(_body):
	player_detected = true
	start_attack()


func _on_player_detect_area_body_exited(_body):
	player_detected = false


func on_died():
	start_invicible()
	broken = true
	breaking = true
	animation_player.play("break")
	await animation_player.animation_finished
	breaking = false
