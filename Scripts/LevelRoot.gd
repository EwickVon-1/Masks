extends Node

@onready var playerController = get_node("Player")
@onready var enemyController = get_node("EnemyManager")
@onready var gridManager = get_node("GridManager")
@onready var levelManager = get_node("LevelManager")


func load_level(index : int) -> bool:
	var level_data = levelManager.load_map(index)
	
	if not level_data:
		return false
	
	# Initalize all cells in GridManager
	gridManager.initialize_cells(level_data["empty"])

	
	# Load the Player
	playerController.CurrPos = level_data["player"]
	playerController.global_position = gridManager.grid_to_world(level_data["player"])
	gridManager.place_agent(playerController, level_data["player"]) 
	
	# Load the Enemies
	for enemy in level_data["enemy"]:
		enemyController.spawn_enemy(enemy)
		
		print("TileMap global pos:", gridManager.tilemap.global_position)
		print("Cell (0,0) world:", gridManager.tilemap.map_to_local(Vector2i.ZERO))
	
	# Static Objects
	for obj in level_data["static"]:
		gridManager.place_static(obj["type"], obj["pos"])
	return true
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(0)
	turn_cycle()


# Start a turn cycle: Player perceives → Player commits one action → Player action resolves → 
#   Enemies move → Death check → Task progress resolves → Turn ends
func turn_cycle() -> void:
	while true:
		playerController.is_player_turn = true
		
		# Player has finished movement
		await playerController.turn_finished
		print("Player turn ended, CurrPos:", playerController.CurrPos)
		
		playerController.is_player_turn = false
		
		#enemy turn
		enemyController.take_turn()
		await enemyController.turn_finished
		for enemy in enemyController.enemies:
			print("Enemy turn ended, CurrPos: ", enemy.CurrPos)
			print("Actual Position: ", enemy.position)
			if (enemy.CurrPos == playerController.CurrPos):
				death(0)
		

func death(index: int) -> void:
	for enemy in enemyController.enemies:
		enemy.die()
	enemyController.die()
	load_level(0)
