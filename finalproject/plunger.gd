extends Node3D
var picked_up = false
var player : CharacterBody3D
func _physics_process(_delta: float) -> void:
	if picked_up:
		global_position = player.global_position
		global_rotation.y = player.neck.rotation.y
		
func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if not picked_up:
		body.plunged = true
		player = body
		picked_up = true
		scale /= 2
