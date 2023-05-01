extends VisibleOnScreenNotifier2D


func _ready():
	# Make area smaller at first
	# Once screen entered, get it back original size
	scale *= 1.0 / 10.0
	screen_entered.connect(on_screen_entered)
	screen_exited.connect(on_screen_exited)


func on_screen_entered():
	scale *= 10.0


func on_screen_exited():
	get_parent().queue_free()
