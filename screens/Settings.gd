extends Control

# Declare member variables here. Examples:
onready var sceneManager = get_node('/root/SceneManager')

func _on_Back_pressed():
	var previousScene = load("res://screens/Menu.tscn") 
	sceneManager.popScene(previousScene.instance())
