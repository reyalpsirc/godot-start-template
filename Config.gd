extends Node

# this signal can let your main scene know that the player
# started the game
signal start_game

var current_screen = null

func _ready():
	change_screen($TitleScreen)

# When changing screens, make sure to wait until the transition
# animation has finished before calling another
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.get_node('AnimationPlayer'), 'animation_finished')
	current_screen = new_screen
	current_screen.appear()
	yield(current_screen.get_node('AnimationPlayer'), 'animation_finished')

# Below here are the functions connected to each screen's
# signals, i.e. your "map" of what screen connects to
# another.
func _on_TitleScreen_play():
	change_screen($GameScreen)
	emit_signal('start_game')