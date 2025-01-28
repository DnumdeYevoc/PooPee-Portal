extends CharacterBody3D
var speed : int = 1000
var sens : int = 5 #Sensitivity

var count = 0
@onready var neck = $Neck
@onready var cam = $Neck/Camera3D2
var offset :float= 0
@onready var dir:= Vector3(0,0,0)
var gravity := Vector3i(0,-1,0)
var rotate_cam: bool = false
var angle :int= 0
var can_rotate:bool= true
var pooped :bool=false
var plunged := false
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if can_rotate:
				neck.rotate_y(-event.relative.x *0.001*sens*-gravity.y)
				cam.rotate_x(-event.relative.y *0.001*sens*-gravity.y)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	var looking = neck.transform.basis.rotated(Vector3.UP,offset)
	dir = ( looking * Vector3(  Input.get_action_strength("Right")*-gravity.y-Input.get_action_strength("Left")*-gravity.y , 0,Input.get_action_strength("Backward")-Input.get_action_strength("Forward"))).normalized()
	if Input.is_action_just_pressed("Space") and plunged:
		if not speed ==0:
			gravity = -gravity
			angle +=gravity.y*180
			can_rotate = false
			rotate_cam = true
	if rotate_cam:
		#fix to work realtive to cam
		if round(cam.rotation_degrees.z) == angle:
			rotate_cam = false
			can_rotate = true
		elif cam.rotation_degrees.z<-0.1 or cam.rotation_degrees.z >180.1:
			cam.rotation_degrees.z += (5*-gravity.y)
		else:
			cam.rotation_degrees.z += (5*gravity.y)
		
	velocity = Vector3i(dir*speed*delta)+gravity*Globals.GRAVITY
	move_and_slide()
func finish_level():
	if ResourceLoader.exists("res://Map"+str(Globals.CUR_LEVEL+1)+".tscn"):
		Globals.CUR_LEVEL +=1
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://main_menu.tscn")
	
