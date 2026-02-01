extends Node

@onready var gridManager = get_node("../GridManager")

var enemy_scene := preload("res://Nodes/Enemy.tscn")
var enemies = []
signal turn_finished

func spawn_enemy(grid_pos: Vector2i) -> void:
	var enemy_instance = enemy_scene.instantiate()
	add_child(enemy_instance)
	
	enemy_instance.CurrPos = grid_pos
	enemy_instance.position = gridManager.grid_to_world(grid_pos)
	
	gridManager.place_agent(enemy_instance, grid_pos)
	enemies.append(enemy_instance)

func take_turn() -> void:
	for enemy_instance in enemies:
		enemy_instance.is_enemy_turn = true
		enemy_instance.take_turn()
		await enemy_instance.turn_finished
		enemy_instance.is_enemy_turn = false
	
	call_deferred("emit_signal", "turn_finished")
