extends Node

const CellScene = preload("res://Cell.tscn")
const PortalScene = preload("res://Portal.tscn")

@export var Map : PackedScene

var world := []
var cells = []
var portallist :=[]
var count = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
			
			for x in range(0,2):
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
						if not other_portal == self:
							if other_portal.index == portal.index:
								other_portal.other_portal = portal
								portal.other_portal = other_portal
								
					add_child(portal)
					portal.do_updates()
				
		if len(world)== len(tilemap_list):
			for cell in cells:
				cell.update_faces(world)
				
	

			
	count = -1
	map.free()
