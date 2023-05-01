extends Node2D

@onready var don = %Don
@onready var boss_marker = %BossMarker


func _on_boss_gate_passed(player):
	player.switch_state("ragdoll")
	# player.face_right()
	await get_tree().create_timer(1.0).timeout
	player.switch_state("cutscene")
	player.animation_player.play("run")
	var tween = create_tween()
	tween.tween_property(player, "global_position", boss_marker.global_position, 5.0)
	await tween.finished
	player.animation_player.play("idle")
	await get_tree().create_timer(1.0).timeout
	player.switch_state("ground")
	don.activate()
