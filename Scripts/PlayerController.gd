extends CharacterBody2D

@export var tile_size := 32
@export var move_time := 0.04
@onready var grid_manager = get_node("../GridManager")


var CurrPos : Vector2i = Vector2i.ZERO
var is_player_turn := false
signal turn_finished 

var tween
var action_committed := false


func _ready() -> void: 
	grid_manager.place_agent(CurrPos)
	
func _process(_delta : float):
	if not is_player_turn or action_committed:
		return
	
	var dir = Vector2i.ZERO
	if Input.is_action_just_pressed("ui_right"): 
		dir = Vector2i.RIGHT 
	elif Input.is_action_just_pressed("ui_left"): 
		dir = Vector2i.LEFT 
	elif Input.is_action_just_pressed("ui_down"): 
		dir = Vector2i.DOWN 
	elif Input.is_action_just_pressed("ui_up"): 
		dir = Vector2i.UP 
	
	if dir != Vector2i.ZERO:
		action_committed = true
		try_move(dir)


func try_move(dir: Vector2i):
	var target_pos = CurrPos + dir
	
	# collision check
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = grid_manager.grid_to_world(target_pos)
	query.collide_with_areas = false
	query.collide_with_bodies = true

	if space.intersect_point(query).is_empty() and grid_manager.move(CurrPos, target_pos):
		move_to(grid_manager.grid_to_world(target_pos))
		CurrPos = target_pos
	else:
		end_turn()

func move_to(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, move_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(end_turn)

func end_turn() -> void:
	is_player_turn = false
	action_committed = false
	emit_signal("turn_finished")
	
	
