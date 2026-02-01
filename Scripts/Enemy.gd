extends CharacterBody2D

@export var tile_size := 32
@export var move_time := 0.04


var CurrPos : Vector2i = Vector2i.ZERO
var lastKnown
enum States {
	IDLE = 1,
	WANDER = 2,
	CHASE = 3,
	SEARCH = 4,
}


@onready var player = get_node("../../Player")

var is_enemy_turn := false
var choices
var dirfacing = "left"


@onready var grid_manager = get_node("../../GridManager")
signal turn_finished

func take_turn() -> void:
	if not is_enemy_turn:
		return

	# Enemy Logic / Pathfinding
	
	if player:
		var delta_pos = player.CurrPos - CurrPos
		if abs(delta_pos.x) > abs(delta_pos.y):
			choices = [
				Vector2i(sign(delta_pos.x), 0),   # move toward player on X
				Vector2i(0, sign(delta_pos.y)),   # then Y
				Vector2i(-sign(delta_pos.x), 0),  # backtrack X
				Vector2i(0, -sign(delta_pos.y)),  # backtrack Y
				Vector2i.ZERO                     # wait
			]
		else:
			choices = [
				Vector2i(0, sign(delta_pos.y)),   # move toward player on Y
				Vector2i(sign(delta_pos.x), 0),   # then X
				Vector2i(0, -sign(delta_pos.y)),  # backtrack Y
				Vector2i(-sign(delta_pos.x), 0),  # backtrack X
				Vector2i.ZERO                     # wait
			]
		
		for dir in choices:
			if dir == Vector2i.ZERO:
				end_turn()
				return
			
			if try_move(dir):
				return

func try_move(dir: Vector2i) -> bool:
	var target_pos = CurrPos + dir
	
	if CurrPos.x - target_pos.x < 0:
		dirfacing = "right"
	elif CurrPos.x - target_pos.x > 0:
		dirfacing = "left"
	
	if grid_manager.move(self, CurrPos, target_pos):
		move_to(grid_manager.grid_to_world(target_pos))
		CurrPos = target_pos
		return true
	else:
		return false
		
		
func move_to(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, move_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(end_turn)

func end_turn() -> void:
	is_enemy_turn = false
	call_deferred("emit_signal", "turn_finished")

func die() -> void:
	queue_free()
