extends Area2D

@export var Level : int 

func _on_mouse_entered() -> void:
	$Door.frame = 1
	$Button.text = "Play Level "+str(Level)
	$Button.visible = true

func _on_button_pressed() -> void:
	Globals.CUR_LEVEL = Level
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_mouse_exited() -> void:
	$Door.frame = 0
	$Button.visible = false
