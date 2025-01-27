extends Node
var offset = 0


func _ready() -> void:
	update_doors()
func update_doors():
	
	$HBoxContainer/LevelDisplay.Level = offset
	$HBoxContainer/LevelDisplay2.Level =1+ offset
	$HBoxContainer/LevelDisplay3.Level =2+ offset



func _on_left_pressed() -> void:
	if not offset == 0:
		offset -= 1
		update_doors()


func _on_right_pressed() -> void:
	if ResourceLoader.exists("res://Map"+str(offset+3)+".tscn"):
		offset +=1
		update_doors()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
