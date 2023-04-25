extends EnemyBase

@onready var ground_detector = %GroundDetector
@onready var wall_detector = %WallDetector
@onready var animation_player = $AnimationPlayer
@onready var activate_timer = $ActivateTimer
@onready var health_component = $HealthComponent
@onready var spike_animation_player = $SpikeAnimationPlayer

enum STATE{IDLE, SHELL, ROLLING}
var current_state = STATE.IDLE

var speed = 10.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1
var activated = false
var died = false
var rolling_speed = 50.0


func _ready():
	super._ready()
	health_component.died.connect(on_died)
	activate_timer.timeout.connect(on_activate_timer_timeout)
	activate_timer.start()
	animation_player.play("idle")


func turn_h():
	super.turn_h()
	direction *= -1


func _physics_process(delta):
	if died:
		return
	
	match current_state:
		STATE.IDLE:
			velocity.y -= gravity * delta
			
			if activated:
				if ground_detector.is_colliding() && !wall_detector.is_colliding():
					velocity.x = direction * speed
				else:
					velocity.x = 0
					stop_and_turn()
			
			move_and_slide()
		STATE.ROLLING:
			velocity = Vector2(direction * rolling_speed, velocity.y + gravity * delta)
			var colliding = move_and_collide(velocity * delta, true)
			move_and_slide()
			
			if colliding:
				var normal = colliding.get_normal()
				if normal.x * direction < 0:
					turn_h()
				if normal.y < 0:
					velocity.y = -320
					spike_animation_player.stop()
					spike_animation_player.play("spike")
		_:
			move_and_slide()


func stop_and_turn():
	activated = false
	await get_tree().create_timer(2).timeout
	turn_h()
	activated = true


func start_rolling():
	current_state = STATE.ROLLING
	animation_player.play("rolling")


func on_activate_timer_timeout():
	activated = true


func on_died():
	died = true
	if current_state == STATE.IDLE:
		animation_player.play("die")
	else:
		animation_player.play("die_shell")


func _on_player_detect_area_body_entered(_body):
	if current_state == STATE.IDLE:
		current_state = STATE.SHELL
		velocity = Vector2.ZERO
		animation_player.play("shell")
		await animation_player.animation_finished
		start_rolling()
