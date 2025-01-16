
class_name Portal
extends Area3D


@export var other_portal : Portal 
@export var cull_layer : int = 4

@export var portal_area_z_margin := 1.0
@export var portal_area_x_margin := 0.1
@export var portal_area_y_margin := 0.1

@export var size : = Vector2(1,2)

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
	$CollisionShape3D.disabled = not self.visible
	#collision
	
	
	update_camera_to_other_portal()
	update_size()
	
func _process(delta):
	update_size()
	
func _physics_process(delta):
	do_updates()
	
	
func _ready():
	
	if Engine.is_editor_hint():
		pass
	$PortalVisual.set_layer_mask_value(1, false)
	$PortalVisual.set_layer_mask_value(cull_layer, true)
	$CameraViewport/Camera3D.set_cull_mask_value(other_portal.cull_layer, false)
	update_size()
	no_tonemap()
	
func update_size():
	$PortalVisual.size.x = self.size.x
	$PortalVisual.size.y = self.size.y
	$CollisionShape3D.shape.size = Vector3(
		self.size.x + self.portal_area_x_margin * 2,
		self.size.y + self.portal_area_y_margin * 2,
		self.portal_area_z_margin * 2)
		
func no_tonemap():
	var world_3d = get_viewport().world_3d
	if not world_3d or not world_3d.environment:
		return
	
	$CameraViewport/Camera3D.environment = world_3d.environment.duplicate()
	$CameraViewport/Camera3D.environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR

func teleport(body: PhysicsBody3D):
	print("teleported")
	var rel_this_portal = self.global_transform.affine_inverse()* body.global_transform
	var move = other_portal.global_transform * rel_this_portal
	body.global_tranform = move
	
	other_portal.do_updates()

func _on_body_entered(body: Node3D) -> void:
	teleport(body)
	
