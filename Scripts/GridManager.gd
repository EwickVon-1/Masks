extends Node2D 

@export var TILE_SIZE := 32

@onready var tilemap

var agent_occupancy: Dictionary = {}
var static_occupancy: Dictionary = {}
var level := 0

func initialize_cells(cells) -> void:
	agent_occupancy.clear()
	static_occupancy.clear()

	for cell in cells:
		agent_occupancy[cell] = null
		static_occupancy[cell] = {
			"wall": false,
			"door": false,
			"spike": false,
			"key": false
		}	

# Converts grid position (x, y) to the world position in pixels 
func grid_to_world(cell: Vector2i) -> Vector2: 
	return tilemap.to_global(tilemap.map_to_local(cell))

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
	if not static_occupancy.has(cell):
		return
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
