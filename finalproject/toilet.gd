extends Node3D

var twice :bool
func _on_area_3d_body_entered(body: Node3D) -> void:
	if twice:
		body.finish_level()
		twice = false
	twice = true
