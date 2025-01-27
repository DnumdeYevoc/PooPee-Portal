extends Node

const CellScene = preload("res://Cell.tscn")
const PortalScene = preload("res://Portal.tscn")
const ToiletScene = preload("res://toilet.tscn")
const LightScene = preload("res://light.tscn")
const PoopScene = preload("res://poop.tscn")
var mapname : String = "res://Map%s.tscn"
@export var Map : PackedScene
var world := []
var cells = []
var portallist :=[]
var count = -1
@onready var bar := $Bar
var level_time :int= 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var name = mapname %  Globals.CUR_LEVEL
	Map = load(name)
	level_time = Globals.LEVEL_TIMES[Globals.CUR_LEVEL]
	bar.max_value = level_time
	bar.value = level_time
	$LosingScreen.visible = false
	$Player.speed = 1000
	#set up envrionment specific ambiance
	generate_map()



func generate_map():
	if not Map is PackedScene: return
	var map = Map.instantiate()
	var tilemap_list = map.get_tilemaps()
	
	for tilemap in tilemap_list:
		count +=1
		var used_tiles = tilemap.get_used_cells()
		world.append(used_tiles)
		for tile in used_tiles:
			
			var cell = CellScene.instantiate()
			add_child(cell)
			cell.position = Vector3(tile.x*Globals.GRID_SIZE,count*Globals.GRID_SIZE,tile.y*Globals.GRID_SIZE)
			cells.append(cell)
			if tilemap.get_cell_atlas_coords(tile)== Vector2i(1,0):
				var toilet = ToiletScene.instantiate()
				toilet.position = Vector3(tile.x*Globals.GRID_SIZE,count*Globals.GRID_SIZE,tile.y*Globals.GRID_SIZE)
				toilet.scale *= Globals.GRID_SIZE*1.25
				toilet.rotation_degrees.y = tilemap.get_cell_source_id(tile)*90
				add_child(toilet)
			if tilemap.get_cell_atlas_coords(tile)== Vector2i(2,0):
				var light = LightScene.instantiate()
				light.position = Vector3(tile.x*Globals.GRID_SIZE,count*Globals.GRID_SIZE,tile.y*Globals.GRID_SIZE)
				light.scale *= Globals.GRID_SIZE
				
				add_child(light)
			if tilemap.get_cell_atlas_coords(tile)== Vector2i(3,0):
				var poop = PoopScene.instantiate()
				poop.position = Vector3(tile.x*Globals.GRID_SIZE,count*Globals.GRID_SIZE,tile.y*Globals.GRID_SIZE)
				poop.scale *= Globals.GRID_SIZE
				
				add_child(poop)
				
			for x in range(0,9):
				#portal
				if tilemap.get_cell_atlas_coords(tile)== Vector2i(x,1):
					var portal = PortalScene.instantiate()
					portal.index= x
					portal.position = Vector3(tile.x*Globals.GRID_SIZE,count*Globals.GRID_SIZE,tile.y*Globals.GRID_SIZE)
					portal.size = Vector2(Globals.GRID_SIZE,Globals.GRID_SIZE)
					portal.rot = tilemap.get_cell_source_id(tile)
					portallist.append(portal)
					#portallinking
					for other_portal in portallist:
						if not other_portal == portal:
							if other_portal.index == portal.index:
								other_portal.other_portal = portal
								portal.other_portal = other_portal
								
					add_child(portal)
					
				
		if len(world)== len(tilemap_list):
			for cell in cells:
				cell.update_faces(world)
				
	

	for portal in portallist:
		if not portal.other_portal == null:
			portal.ready__()
			portal.do_updates()
	count = -1
	map.free()
	
func _physics_process(delta: float) -> void:
	bar.value -= 1*delta
	if bar.value <=0:
		$LosingScreen/YouPeedUrself.visible = true
		$LosingScreen/YouStink.visible = false
		$LosingScreen.visible = true
		$Player.speed =0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if $Player.pooped:
		$LosingScreen/YouPeedUrself.visible = false
		$LosingScreen/YouStink.visible = true
		$LosingScreen.visible = true
		$Player.speed =0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
