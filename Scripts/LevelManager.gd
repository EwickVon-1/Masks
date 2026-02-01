extends Node

var levels : Array[TileMapLayer] = []
@onready var gridManager = get_node("../GridManager")


enum TileID {
	WALL = 1,
	PLAYER = 2,
	SPIKE = 3,
	DOOR = 4,
	ENEMY = 5,
	KEY = 6
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_level_data(self)
	
func get_level_data(node: Node) -> void:
	for subnode in node.get_children():
		if subnode is TileMapLayer:
			levels.append(subnode)

func load_map(index : int):
	if index < 0 or index >= levels.size():
		return null
	
	var level_data : TileMapLayer = levels[index]
	
	if not level_data:
		return null
		
	var level_info = {
		"empty" : [],
		"player" : Vector2i.ZERO,
		"enemy" : [],
		"static" : []
	}
	
	gridManager.tilemap = level_data
	
	for cell in level_data.get_used_cells():
		var tile_id := level_data.get_cell_source_id(cell)
		
		if tile_id == TileID.WALL:
			level_info["static"].append({"type": "wall", "pos": cell})
			print("wall at: ", cell)
		elif tile_id == TileID.PLAYER:
			level_info["player"] = cell
			level_info["empty"].append(cell)
			print("player at: ", cell)
		elif tile_id == TileID.SPIKE:
			level_info["static"].append({"type": "spike", "pos": cell})
			print("spike at: ", cell)
		elif tile_id == TileID.DOOR:
			level_info ["static"].append({"type": "door", "pos": cell})
			print("door at: ", cell)
		elif tile_id == TileID.ENEMY:
			level_info["enemy"].append(cell)
			level_info["empty"].append(cell)
			print("enemy at: ", cell)
		elif tile_id == TileID.KEY:
			level_info["static"].append({ "type": "key", "pos": cell })
		else:
			level_info["empty"].append(cell)
			
	return level_info
