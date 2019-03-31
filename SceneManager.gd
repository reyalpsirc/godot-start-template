extends Control

# Declare member variables here. Examples:
var startScene = preload("res://screens/Menu.tscn")
var currentScene
var loader
var wait_frames
var loadingNode
var loadingPreInst = preload("res://gui/Loading.tscn")
var next_resource
var time_max = 100 # msec

# Called when the node enters the scene tree for the first time.
func _ready():
	$Other.modulate.a = 0
	$Main.modulate.a = 1
	# Load up the first scene
	currentScene = startScene.instance()
	$Main/Viewport.add_child(currentScene)
	
func pushScene(scene):
	get_tree().get_root().set_disable_input(true)
	$Main/Viewport.remove_child(currentScene)
	$Other/Viewport.add_child(currentScene)
	$Other.modulate.a = 1
	$Main.modulate.a = 0
	$Main/Viewport.add_child(scene)
	currentScene = scene
	$AnimationPlayer.play("nextScene")
	
func popScene(scene):
	get_tree().get_root().set_disable_input(true)
	$Other.modulate.a = 0
	$Main.modulate.a = 1
	$Other/Viewport.add_child(scene)
	currentScene = scene
	$AnimationPlayer.play("previousScene")

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "previousScene"):
		for child in $Main/Viewport.get_children():
			child.queue_free()
		$Other/Viewport.remove_child(currentScene)
		$Main/Viewport.add_child(currentScene)
	$Main.modulate.a = 1
	$Other.modulate.a = 0
	get_tree().get_root().set_disable_input(false)
		

func openWithLoading(path):
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		return
	loadingNode=loadingPreInst.instance()
	currentScene.add_child(loadingNode)
	wait_frames = 0
	
func _process(delta):
	if (loader):
		if wait_frames > 0: # wait for frames to let the "loading" animation to show up
			wait_frames -= 1
			return
		var t = OS.get_ticks_msec()
		while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
			# poll your loader
			var err = loader.poll()
			if err == ERR_FILE_EOF: # load finished
				loadingNode.setProgress(100)
				next_resource = loader.get_resource()
				loader = null
				wait_frames=1
				break
			elif err==OK:
				if (loadingNode):
					var progress = float(loader.get_stage()) / loader.get_stage_count()
					loadingNode.setProgress(round(progress*100))
			else: # error during loading
				loader = null
				break
	if (loader==null and next_resource!=null):
		if wait_frames > 0: # wait for frames to let the "loading" animation to show up
			wait_frames -= 1
			return
		pushScene(next_resource.instance())
		next_resource=null