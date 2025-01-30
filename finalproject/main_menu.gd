extends Node

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")


func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
