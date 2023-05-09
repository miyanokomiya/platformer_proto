extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var translate_marker = $TranslateMarker
@onready var trap_marker = $TrapMarker

enum STATE{IDLE, CLOSED, BROKEN}
var current_state = STATE.IDLE
var target: Node2D


func _physics_process(_delta):
	if current_state == STATE.CLOSED:
		if target:
			target.global_position = trap_marker.global_position


func activate():
	if current_state != STATE.IDLE:
		return
	
	current_state = STATE.CLOSED
	animation_player.play("enclose")
	var tween = create_tween()
	tween.tween_property(self, "global_position", translate_marker.global_position, 0.4)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)


func get_broken():
	if current_state != STATE.CLOSED:
		return
	
	target = null
	current_state = STATE.BROKEN
	animation_player.play("break")


func _on_activate_area_body_entered(body: Node2D):
	if body.global_position.y > global_position.y:
		return
	
	target = body
	activate()


func _on_health_component_died():
	get_broken()
