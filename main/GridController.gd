extends Node

var grid = []
onready var ground = get_node("/root/Main/Ground")
onready var config = get_node("/root/Main/").config

func init():
	for x in range(5):
		grid.append([])
		grid[x]=[]
		for y in range(5):
			grid[x].append([])
			grid[x][y]=0

func display_grid():
	for i in range(5):
		var row = []
		for j in range(5):
			var element = grid[i][j]
			row.append(element if typeof(element) == TYPE_INT else str(element.height)) 
		print(row)
	print('------------------------------------')

func check_grid():
	check_group_collisions()
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
		get_tree().change_scene("res://ui/game_over/GameOver.tscn")
 
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
						yield(get_tree().create_timer(config.time_delay), "timeout")
						ground.grow_tile(Vector2(i,j), units[i][j].height)
						ground.remove_from_tile(Vector2(i, j+1))
						collided = true
					else:
						units[i][j+1].height += 1
						units[i][j] = 0
						yield(get_tree().create_timer(config.time_delay), "timeout")
						ground.grow_tile(Vector2(i,j+1), units[i][j+1].height)
						ground.remove_from_tile(Vector2(i, j))
						collided = true
	for i in range(4):
		for j in range(5):
			if units[i][j] and units[i+1][j]:
				if units[i][j].color == units[i+1][j].color and units[i][j].height == units[i+1][j].height:
					if units[i][j].age <= units[i+1][j].age:
						units[i][j].height += 1
						units[i+1][j] = 0
						yield(get_tree().create_timer(config.time_delay), "timeout")
						ground.grow_tile(Vector2(i,j), units[i][j].height)
						ground.remove_from_tile(Vector2(i+1, j))
						collided = true
					else:
						units[i+1][j].height += 1
						units[i][j] = 0
						yield(get_tree().create_timer(config.time_delay), "timeout")
						ground.grow_tile(Vector2(i+1,j), units[i+1][j].height)
						ground.remove_from_tile(Vector2(i, j))
						collided = true
	if collided:
		check_collisions()

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
	var unit = grid[pos.x][pos.y]
	var similar_units = []
	var adjacent_units = get_adjacent_units_with_pos(pos)
	for adj_unit in adjacent_units:
		if (unit.color == adj_unit[0].color and unit.height == adj_unit[0].height):
			similar_units.append(adj_unit)
	return similar_units

func check_group_collisions():
	for i in range(5):
		for j in range(5):
			if(grid[i][j]):
				var s_colliders = get_abjacent_similar_units_with_pos(Vector2(i,j))
				if s_colliders.size() > 1:
					var new_height =  grid[i][j].height + s_colliders.size()
					grid[i][j].height = new_height
					yield(get_tree().create_timer(config.time_delay), "timeout")
					ground.grow_tile(Vector2(i,j), new_height)
					for s_collider in s_colliders:
						ground.remove_from_tile(s_collider[1])
