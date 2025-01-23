extends Node

const Cell = preload("res://Cell.tscn")

@export var Map : PackedScene

var cells = []

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
	var tilemap = map.get_tilemap()
	var used_tiles = tilemap.get_used_cells()
	map.free()
	for tile in used_tiles:
		var cell = Cell.instantiate()
		add_child(cell)
		cell.position = Vector3(tile.x*Globals.GRID_SIZE,1,tile.y*Globals.GRID_SIZE)
		cells.append(cell)
		print("added_cell")
	for cell in cells:
		cell.update_faces(used_tiles)
