extends CanvasLayer
var UnitClass = load('res://Unit.gd')

var units = []

var red = Color('e63946')
var blue = Color('457b9d')
var green = Color('2a9d8f')
var yellow = Color('fcbf49')
var color_dict = [red, blue, green, yellow]
var grid = []

func _ready():
	generate_units(4)
	init_grid()
	$Units.inventory_update(units)
	
func get_selected_unit():
	return units[0]

func _on_Ground_unit_placed(pos, unit):
	grid[pos.x][pos.y] = unit
	grow_units(pos)
	units.pop_front()
	queue_random_unit()
	$Units.inventory_update(units)

func generate_units(size):
	for i in range(0, size):
		queue_random_unit()

func queue_random_unit():
	var random_color = color_dict[randi() % color_dict.size() - 1]
	units.append(UnitClass.new(random_color, 1, 1))

func init_grid():
	for x in range(5):
		grid.append([])
		grid[x]=[]
		for y in range(5):
			grid[x].append([])
			grid[x][y]=0

func get_adjacent_positions(pos):
	var adjacent_positions = []
	var row = pos.x
	var col = pos.y
	if row > 0:
		adjacent_positions.append(Vector2(row - 1, col))
	if row < 4:
		adjacent_positions.append(Vector2(row + 1, col))
	if col > 0:
		adjacent_positions.append(Vector2(row, col - 1))
	if col < 4:
		adjacent_positions.append(Vector2(row, col + 1))
	return adjacent_positions

func get_adjacent_units_with_pos(pos):
	var units_and_pos = []

	var positions = get_adjacent_positions(pos)
	for i in positions:
		var unit = grid[i.x][i.y]
		if(typeof(unit) != TYPE_INT):
			units_and_pos.append([unit, i])
	return units_and_pos

func get_abjacent_similar_units_with_pos(pos):
	var unit = get_selected_unit()
	var similar_units = []
	var adjacent_units = get_adjacent_units_with_pos(pos)
	for adj_unit in adjacent_units:
		if (unit.color == adj_unit[0].color):
			similar_units.append(adj_unit)
	return similar_units

func grow_units(pos):
	var siblings = get_abjacent_similar_units_with_pos(pos)
	if(siblings.size() == 1 and grid[siblings[0][1].x][siblings[0][1].y].height == 1):
		grid[siblings[0][1].x][siblings[0][1].y].height += 1
		yield(get_tree().create_timer(0.4), "timeout")
		$Ground.grow_on_tile(siblings[0][1])
		$Ground.remove_from_tile(pos)
	
