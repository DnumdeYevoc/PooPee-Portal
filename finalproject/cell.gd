extends Node3D

class_name Cell

@onready var topface:= $TopFace
@onready var bottomface:= $BottomFace
@onready var northface:= $NorthFace
@onready var eastface:= $EastFace
@onready var westface:= $WestFace
@onready var southface:= $SouthFace
var world := []
var count :int = -1
func _ready() -> void:
	for child in get_children():
		child.position *= Vector3(Globals.GRID_SIZE/2,Globals.GRID_SIZE/2,Globals.GRID_SIZE/2)
		child.scale = Vector3(Globals.GRID_SIZE,Globals.GRID_SIZE,Globals.GRID_SIZE)
		

func update_faces(cell_list):
	world.append(cell_list)
	var my_grid_pos = Vector2i(position.x/Globals.GRID_SIZE, position.z/Globals.GRID_SIZE)
	if cell_list.has(my_grid_pos + Vector2i.RIGHT):
		eastface.hide()
		eastface.get_child(0).get_child(0).disabled = true
	if cell_list.has(my_grid_pos + Vector2i.LEFT):
		westface.hide()
		westface.get_child(0).get_child(0).disabled = true
	if cell_list.has(my_grid_pos + Vector2i.DOWN):
		northface.hide()
		northface.get_child(0).get_child(0).disabled = true
	if cell_list.has(my_grid_pos + Vector2i.UP):
		southface.hide()
		southface.get_child(0).get_child(0).disabled = true
	#3d maps
	for layer in world:
		count+=1

		for cell in layer:
			var len:=len(world)
			
			if len >1:
				if count<len:
					if world[count+1].has(cell):
						
						topface.hide()
						topface.get_child(0).get_child(0).disabled = true
				elif count>0:
					if world[count-1].has(cell):
						print("bottom_hide")
						bottomface.hide()
						bottomface.get_child(0).get_child(0).disabled = true
		count = -1
