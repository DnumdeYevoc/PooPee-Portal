extends Node3D

class_name Cell

@onready var topface:= $TopFace
@onready var bottomface:= $BottomFace
@onready var northface:= $NorthFace
@onready var eastface:= $EastFace
@onready var westface:= $WestFace
@onready var southface:= $SouthFace


func update_faces(cell_list):
	
	var my_grid_pos = Vector2i(position.x/Globals.GRID_SIZE, position.z/Globals.GRID_SIZE)
	if cell_list.has(my_grid_pos + Vector2i.RIGHT):
		eastface.hide()
	
	if cell_list.has(my_grid_pos + Vector2i.LEFT):
		westface.hide()
		
	if cell_list.has(my_grid_pos + Vector2i.DOWN):
		northface.hide()


	if cell_list.has(my_grid_pos + Vector2i.UP):
		southface.hide()
	
		
		
