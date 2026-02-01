extends Node2D 
@export var TILE_SIZE := 32 

var occupancy: Dictionary = {}

@onready var tilemap = $"../TileMapLayer"

 # Called when the node enters the scene tree for the first time. 
func _ready() -> void: 
	for cell: Vector2i in tilemap.get_used_cells():
		occupancy[cell] = false

# Converts grid position (x, y) to the world position in pixels 
func grid_to_world(cell: Vector2i) -> Vector2: 
	return Vector2(cell.x * TILE_SIZE, cell.y * TILE_SIZE) 

# Converts world position in pixels to the grid position 
func world_to_grid(pos: Vector2) -> Vector2i: 
	return Vector2i(
		floori(pos.x / TILE_SIZE), 
		floori(pos.y / TILE_SIZE)) 

# Returns true if the object is within the map bounds 
func is_inside(object_pos: Vector2i) -> bool: 
	return occupancy.has(object_pos)

func get_cell(cell: Vector2i) -> bool: 
	return occupancy.get(cell) 

func place_agent(cell: Vector2i): 
	occupancy[cell] = true 
	
func can_move(target: Vector2i) -> bool:
	return is_inside(target) and occupancy[target] == false

func empty_cell(cell: Vector2i): 
	occupancy[cell] = false 

func move(agent_cell : Vector2i, target: Vector2i) -> bool: 
	if not can_move(target): 
		return false 
	
	empty_cell(agent_cell) 
	place_agent(target) 
	return true
