extends Node2D

@onready var don = %Don
@onready var boss_marker = %BossMarker
@onready var level_manage_component = $LevelManageComponent


func _on_boss_gate_passed(player):
	player.switch_state("ragdoll")
	await get_tree().create_timer(1.0).timeout
	player.switch_state("cutscene")
	player.animation_player.play("run")
	var tween = create_tween()
	tween.tween_property(player, "global_position", boss_marker.global_position, 5.0)
	await tween.finished
	player.animation_player.play("idle")
	await get_tree().create_timer(1.0).timeout
	don.activate()
	await don.activated
	await get_tree().create_timer(1.0).timeout
	player.switch_state("ground")


func _on_don_died():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if !player:
		return
	
	player.switch_state("ragdoll")


func _on_don_exploded():
	level_manage_component.victory()
	
