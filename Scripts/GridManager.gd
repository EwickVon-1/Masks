extends Node2D 

@export var TILE_SIZE := 5

var agent_occupancy: Dictionary = {}
var static_occupancy: Dictionary = {}
var level := 0

	
# Converts grid position (x, y) to the world position in pixels 
func grid_to_world(cell: Vector2i) -> Vector2: 
	return Vector2(cell.x * TILE_SIZE, cell.y * TILE_SIZE) 

# Converts world position in pixels to the grid position 
func world_to_grid(pos: Vector2) -> Vector2i: 
	return Vector2i(
		floori(pos.x / TILE_SIZE), 
		floori(pos.y / TILE_SIZE)) 

# Returns true if the agent is within the map bounds 
func is_inside(agent_pos: Vector2i) -> bool: 
	return static_occupancy.has(agent_pos)

func place_agent(agent : Node, cell: Vector2i): 
	agent_occupancy[cell] = agent

func is_blocked(cell: Vector2i) -> bool:
	
	if static_occupancy[cell]["wall"]:
		return true
		
	return false
	
func place_static(type, cell: Vector2i) -> void:
	static_occupancy[cell] = {"wall": false,
								"door": false,
								"spike": false,
								"key": false }
	static_occupancy[cell][type] = true
	
func can_move(target: Vector2i) -> bool:
	return is_inside(target) and not is_blocked(target)

func empty_cell(cell: Vector2i): 
		agent_occupancy[cell] = null

func move(agent : Node, initial : Vector2i, target: Vector2i) -> bool: 
	if not can_move(target): 
		return false 
	
	empty_cell(initial) 
	place_agent(agent, target) 
	return true
