extends Node

@onready var playerController = get_node("Player")
@onready var enemyController = get_node("EnemyManager")
@onready var gridManager = get_node("GridManager")
@onready var levelManager = get_node("LevelManager")


func load_level(index : int) -> bool:
	var level_data = levelManager.load_map(index)
	
	if not level_data:
		return false
	
	# Load all moveable tiles (define occupancy)
	for cell in level_data["empty"]:
		gridManager.agent_occupancy[cell] = null
		gridManager.static_occupancy[cell] = {
									"wall": false,
									"door": false,
									"spike": false,
									"key": false }

	
	# Load the Player
	playerController.CurrPos = level_data["player"]
	playerController.position = gridManager.grid_to_world(level_data["player"])
	gridManager.place_agent(playerController, level_data["player"]) 
	gridManager.static_occupancy[level_data["player"]] = {"wall": false,
										"door": false,
										"spike": false,
										"key": false }
	
	# Load the Enemies
	for enemy in level_data["enemy"]:
		enemyController.spawn_enemy(enemy)
		gridManager.static_occupancy[enemy] = {"wall": false,
											"door": false,
											"spike": false,
											"key": false }
	
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
		
		#end loop
	
