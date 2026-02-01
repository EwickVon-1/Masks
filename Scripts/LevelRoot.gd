extends Node

@onready var playerController = get_node("Player")
@onready var enemyController = get_node("Enemy-01")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		
		enemyController.is_enemy_turn = true
		#enemy turn
		enemyController.take_turn()
		await enemyController.turn_finished
		print("Enemy turn ended, CurrPos:", enemyController.CurrPos)
		
		enemyController.is_enemy_turn = false
		#end loop
		
		if playerController.CurrPos == enemyController.CurrPos:
			print("\n\nYou Died!!\n\n")
			playerController.CurrPos = Vector2i.ZERO
			enemyController.CurrPos = [5, 5]
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
