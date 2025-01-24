extends Node

const Cell = preload("res://Cell.tscn")

@export var Map : PackedScene

var cells = []
var count = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set up envrionment specific ambiance
	generate_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func generate_map():
	if not Map is PackedScene: return
	var map = Map.instantiate()
	var tilemap_list = map.get_tilemaps()
	
	for tilemap in tilemap_list:
		count +=1
		var used_tiles = tilemap.get_used_cells()
		for tile in used_tiles:
			var cell = Cell.instantiate()
			add_child(cell)
			cell.position = Vector3(tile.x*Globals.GRID_SIZE,count*Globals.GRID_SIZE,tile.y*Globals.GRID_SIZE)
			cells.append(cell)
		for cell in cells:
			cell.update_faces(used_tiles)
		count = -1
	map.free()
