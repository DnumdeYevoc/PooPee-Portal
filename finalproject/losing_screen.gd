extends Node


func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()
