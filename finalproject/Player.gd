extends CharacterBody3D
var speed : int = 1000
var sens : int = 5 #Sensitivity



@onready var neck = $Neck
@onready var cam = $Neck/Camera3D2


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x *0.001*sens)
			cam.rotate_x(-event.relative.y *0.001*sens)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	var dir : Vector3 = (neck.transform.basis * Vector3(  Input.get_action_strength("Right")-Input.get_action_strength("Left") , 0,Input.get_action_strength("Backward")-Input.get_action_strength("Forward"))).normalized()
	
	velocity = Vector3(dir*speed*delta)
	move_and_slide()
