extends RigidBody2D

# This scene is supposed to be instantiated by "FallenPartComponent"


func _on_off_screen_component_screen_exited():
	queue_free()
