extends CharacterBody3D
var speed : float = 300.0

@onready var neck = $Neck
@onready var cam = $Neck/Camera3D2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y-(event.relative.x *0.01)
			cam.rotate_x(-event.relative.y *0.01)
			
func _physics_process(delta: float) -> void:
	var dir : Vector3 = Vector3( Input.get_action_strength("Forward")-Input.get_action_strength("Backward") , 0, Input.get_action_strength("Right")-Input.get_action_strength("Left"))
	
	velocity = Vector3(dir*speed*delta)
	print(dir)
	move_and_slide()
