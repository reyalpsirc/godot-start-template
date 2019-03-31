extends Control

# Declare member variables here. Examples:
onready var sceneManager = get_node('/root/SceneManager')

func _on_Settings_pressed():
	var nextScene = load("res://screens/Settings.tscn") # Will load when parsing the script.
	sceneManager.pushScene(nextScene.instance())


func _on_Play_pressed():
	sceneManager.openWithLoading("res://screens/Game.tscn")
