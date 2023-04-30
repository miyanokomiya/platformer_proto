extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var heal_value: int = 4
@export var no_time_limit: bool = false

@onready var animation_player = $AnimationPlayer
@onready var time_disappear_component = $TimeDisappearComponent


func _ready():
	if !no_time_limit:
		time_disappear_component.start()


func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()


func _on_pickable_component_picked(player: Player):
	if player.health_component.heal(heal_value) > 0:
		animation_player.play("picked")
		await animation_player.animation_finished
	
	queue_free()


func _on_time_disappear_component_timeout():
	queue_free()
