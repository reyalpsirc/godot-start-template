extends Viewport

func _ready():
	get_tree().get_root().connect("size_changed", self, "window_resize")
	window_resize()

func window_resize():
	size = get_tree().get_root().size
	set_size_override(true, size)
	