extends CanvasLayer
var UnitClass = load('res://Unit.gd')

var units = []
var turns = 0
var red = Color('e63946')
var blue = Color('457b9d')
var green = Color('2a9d8f')
var yellow = Color('fcbf49')
var color_dict = [red, blue, green, yellow]
var grid = []

func _ready():
	init_grid()
	generate_units(4)
	$Units.inventory_update(units)

func get_selected_unit():
	return units[0]

func _on_Ground_unit_placed(pos):
	grid[pos.x][pos.y] = get_selected_unit()
	place_unit(pos, get_selected_unit())
	check_grid()
	inventory_pop_queue()

func generate_units(size):
	for i in range(0, size):
		queue_random_unit()

func inventory_pop_queue():
	units.pop_front()
	queue_random_unit()
	$Units.inventory_update(units)

func queue_random_unit():
	var random_color = color_dict[randi() % color_dict.size() - 1]
	turns += 1
	units.append(UnitClass.new(random_color, 1, turns))

func init_grid():
	for x in range(5):
		grid.append([])
		grid[x]=[]
		for y in range(5):
			grid[x].append([])
			grid[x][y]=0

func loop_grid(grid: Array):
	for i in range(5):
		for j in range(5):
			if grid[i][j]:
				var pos = Vector2(i, j)
				place_unit(pos, grid[i][j])

func place_unit(pos, unit):
	$Ground.grow_new_tile(pos, unit)

func display_grid():
	for i in range(5):
		var row = []
		for j in range(5):
			var element = grid[i][j]
			row.append(element if typeof(element) == TYPE_INT else str(element.height)) 
		print(row)
	print('------------------------------------')

func check_grid():
	check_collisions()
	check_game_over()

func check_game_over():
	var units = grid
	var game_over = true
	for i in range(5):
		for j in range(5):
			if typeof(units[i][j]) == TYPE_INT:
				game_over = false
	if game_over:
		print("Game Over")
 
func check_collisions():
	var units = grid
	var collided = false
	for i in range(5):
		for j in range(4):
			if units[i][j] and units[i][j+1]:
				if units[i][j].color == units[i][j+1].color and units[i][j].height == units[i][j+1].height:
					if units[i][j].age <= units[i][j+1].age:
						units[i][j].height += 1
						units[i][j+1] = 0
						$Ground.grow_tile(Vector2(i,j), units[i][j].height)
						$Ground.remove_from_tile(Vector2(i, j+1))
						collided = true
					else:
						units[i][j+1].height += 1
						units[i][j] = 0
						$Ground.grow_tile(Vector2(i,j+1), units[i][j+1].height)
						$Ground.remove_from_tile(Vector2(i, j))
						collided = true
	for i in range(4):
		for j in range(5):
			if units[i][j] and units[i+1][j]:
				if units[i][j].color == units[i+1][j].color and units[i][j].height == units[i+1][j].height:
					if units[i][j].age <= units[i+1][j].age:
						units[i][j].height += 1
						units[i+1][j] = 0
						$Ground.grow_tile(Vector2(i,j), units[i][j].height)
						$Ground.remove_from_tile(Vector2(i+1, j))
						collided = true
					else:
						units[i+1][j].height += 1
						units[i][j] = 0
						$Ground.grow_tile(Vector2(i+1,j), units[i+1][j].height)
						$Ground.remove_from_tile(Vector2(i, j))
						collided = true
	if collided:
		check_collisions()
