extends CharacterBody2D

@export var tile_size := 32
@export var move_time := 0.04


var CurrPos := Vector2i.ZERO


enum States {
	WANDER = 1,
	CHASE = 2,
	SEARCH = 3,
}


@onready var player = get_node("../../Player")

var is_enemy_turn := false

var choices
var dirfacing = "left"

# State Mechanics
var curr_state = States.WANDER
var player_last_location := Vector2i.ZERO
var chase_timer := 0
var search_timer := 0

enum direction {
	LEFT = 1,
	DOWN = 2,
	RIGHT = 3,
	UP = 4,
	WAIT = 5
}

@onready var grid_manager = get_node("../../GridManager")
signal turn_finished

# Free will?!?!?!?!
func make_choice(state : int, last_known : Vector2i) -> Vector2i:
	choices =  [
				Vector2i.LEFT,
				Vector2i.DOWN,
				Vector2i.RIGHT,
				Vector2i.UP,
				Vector2i.ZERO     
			]
	if state == States.WANDER:
		var random_choice = randi() % 5
		if random_choice == 4:
			random_choice = randi() % 5
		var choice = choices[random_choice]
		return choice
	elif state == States.CHASE:
		var delta_pos = last_known - CurrPos
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
		
		var choice = get_weighted_choice(choices, [60, 25, 10, 3, 2])
		return choice
		
	elif state == States.SEARCH:
		var delta_pos = last_known - CurrPos
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
		
		var choice = get_weighted_choice(choices, [35, 25, 20, 10, 10])
		return choice
	return Vector2i.ZERO
	
func get_weighted_choice(options, weights : Array[int]) -> Vector2i:
	var total := 0
	for weight in weights:
		total += weight
	
	var roll = randi() % total
	
	var acc := 0
	for i in range(options.size()):
		acc += weights[i]
		if roll < acc:
			return options[i]
			
	return options[0]

func change_state(state : int) -> void:
	player_last_location = player.CurrPos
	curr_state = state
	return
	
func detect_player() -> bool:
	var delta = player.CurrPos - CurrPos
	if abs(delta.x) + abs(delta.y) > 6:
		return false
	return true 
	

func take_turn() -> void:
	if chase_timer > 0:
		chase_timer -= 1

	if search_timer > 0:
		search_timer -= 1
		
		
	# Enemy Logic / Pathfinding
	
	if player:
		if detect_player() and chase_timer == 0:
			print(curr_state)
			change_state(States.CHASE)
			chase_timer = 3
		
		if curr_state == States.CHASE and chase_timer == 0:
			change_state(States.SEARCH)
			search_timer = 3
		
		if curr_state == States.SEARCH and search_timer == 0:
			change_state(States.WANDER)
		
		var dir = make_choice(curr_state, player_last_location)
		if dir == Vector2i.ZERO:
			end_turn()
			return
			
		if try_move(dir):
			end_turn()
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
		end_turn()
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
