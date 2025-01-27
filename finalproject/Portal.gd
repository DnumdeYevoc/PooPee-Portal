
class_name Portal
extends Area3D


@export var other_portal : Portal 
@export var cull_layer : int = 4

@export var portal_area_z_margin := 1.0
@export var portal_area_x_margin := 0.1
@export var portal_area_y_margin := 0.1

@export var size : = Vector2(1,2)

var do_teleport: bool = true
var index :int
var rot:int=0
func update_camera_to_other_portal():
	var cur_camera = get_viewport().get_camera_3d()
	if not cur_camera:
		return
		
	var cur_camera_transform_rel_to_this_portal = self.global_transform.affine_inverse() * cur_camera.global_transform
	var moved_to_other_portal = other_portal.global_transform * cur_camera_transform_rel_to_this_portal
	
	$CameraViewport/Camera3D.global_transform = moved_to_other_portal
	$CameraViewport/Camera3D.fov = cur_camera.fov
	
	$CameraViewport/Camera3D.cull_mask = cur_camera.cull_mask
	$CameraViewport/Camera3D.set_cull_mask_value(other_portal.cull_layer, false)
	
	$CameraViewport.size = get_viewport().get_visible_rect().size
	$CameraViewport.msaa_3d = get_viewport().msaa_3d
	$CameraViewport.screen_space_aa = get_viewport().screen_space_aa
	$CameraViewport.use_taa = get_viewport().use_taa
	$CameraViewport.use_debanding = get_viewport().use_debanding
	$CameraViewport.use_occlusion_culling = get_viewport().use_occlusion_culling
	$CameraViewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold
	
	
func do_updates():
	update_camera_to_other_portal()
	update_size()
	

	
func _physics_process(_delta):
	
	do_updates()
	
	
func _ready():
	
	$PortalVisual.set_layer_mask_value(1, false)
	$PortalVisual.set_layer_mask_value(cull_layer, true)
	$CameraViewport/Camera3D.set_cull_mask_value(other_portal.cull_layer, false)
	if rot==0:
		@warning_ignore("integer_division")
		position.z -= (Globals.GRID_SIZE/2)-0.25
	if rot==3:
		@warning_ignore("integer_division")
		
		position.x += (Globals.GRID_SIZE/2)-0.25
	if rot==2:
		@warning_ignore("integer_division")
		position.z += (Globals.GRID_SIZE/2)-0.25
	if rot==1:
		@warning_ignore("integer_division")
		position.x -= (Globals.GRID_SIZE/2)-0.25
	update_size()
func update_size():
	$PortalVisual.size.x = self.size.x
	$PortalVisual.size.y = self.size.y
	$CollisionShape3D.shape.size = Vector3(
		self.size.x + self.portal_area_x_margin * 2,
		self.size.y + self.portal_area_y_margin * 2,
		self.portal_area_z_margin * 2)
	
	if other_portal.rot <= rot:
		if rot-other_portal.rot == 0:
			rotation_degrees.y =  other_portal.rotation_degrees.y
		elif rot-other_portal.rot==1 or 3:
			rotation_degrees.y =90+other_portal.rotation_degrees.y
		elif  rot-other_portal.rot ==2:
			rotation_degrees.y = 180+other_portal.rotation_degrees.y
	else:
		rotation_degrees.y = rot*90
func teleport(body: PhysicsBody3D):
	body.offset +=   other_portal.rotation.y -self.rotation.y
	var rel_this_portal = self.global_transform.affine_inverse() * body.global_transform 
	var move = other_portal.global_transform * rel_this_portal
	body.global_transform = move

	 #fix to make camera rotate with portal
	

	other_portal.do_updates()
	other_portal.do_teleport = false
	
func _on_body_entered(body: Node3D) -> void:
	if do_teleport:
		teleport(body)


func _on_body_exited(_body: Node3D) -> void:
	do_teleport = true
