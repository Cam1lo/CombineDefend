extends StaticBody
signal unit_placed(pos, unit)

var tiles = []

func _ready():
	for child in self.get_children():
		if child.name.begins_with('Mesh'):
			tiles.append(child)
	
	for i in range(0, tiles.size()): 
		tiles[i].pos = i_to_grid_pos(i)
		tiles[i].connect('unit_placed', self, 'unit_placed')


func unit_placed(pos, unit):
	emit_signal("unit_placed", pos, unit)

func grow_on_tile(pos):
	for tile in tiles:
		if (tile.pos == pos):
			tile.grow_box()

func remove_from_tile(pos):
	for tile in tiles:
		if (tile.pos == pos):
			tile.remove_box()

func i_to_grid_pos(i):
	var row = int(i) / 5
	var col = int(i) % 5
	return Vector2(row, col)
