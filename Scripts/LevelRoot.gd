extends Node

@onready var playerController = get_node("Player")


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
		
		#enemy turn
		print("You suck lmao")
		
		#end loop

		
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
