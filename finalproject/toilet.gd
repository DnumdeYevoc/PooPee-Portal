extends Node3D

var twice :bool
func _on_area_3d_body_entered(body: CharacterBody3D) -> void:

	body.finish_level()
	
