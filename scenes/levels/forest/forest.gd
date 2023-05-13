extends Node2D

@onready var air_raid_bomb_spawner = $BackgroundLayer/AirRaidBombSpawner


func _on_air_raid_bomb_camera_bounds_activated():
	air_raid_bomb_spawner.start_shooting()


func _on_air_raid_bomb_camera_bounds_deactivated():
	air_raid_bomb_spawner.stop_shooting()
