extends Node2D
var last_level := false
var time : int
func _on_button_pressed() -> void:
	if last_level:
		get_tree().change_scene_to_file("res://main_menu.tscn")
	else:
		get_tree().reload_current_scene()
func set_time():
	$VBoxContainer/TextEdit.text = "Time : "+str(time)
