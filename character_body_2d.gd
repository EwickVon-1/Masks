extends CharacterBody2D

@export var tile_size := 32
@export var move_time := 0.04

var CurrPos = [0,0]
var moving := false

func _process(_delta):
	if moving:
		return

	var dir := Vector2.ZERO

	if Input.is_action_just_pressed("ui_right"):
		dir = Vector2.RIGHT
		CurrPos[0] += 1
	elif Input.is_action_just_pressed("ui_left"):
		dir = Vector2.LEFT
		CurrPos[0] += -1
	elif Input.is_action_just_pressed("ui_down"):
		dir = Vector2.DOWN
		CurrPos[1] += 1
	elif Input.is_action_just_pressed("ui_up"):
		dir = Vector2.UP
		CurrPos[1] += -1

	if dir != Vector2.ZERO:
		try_move(dir)

func try_move(dir: Vector2):
	var target_pos = position + dir * tile_size

	# collision check
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target_pos
	query.collide_with_areas = false
	query.collide_with_bodies = true

	if space.intersect_point(query).is_empty():
		move_to(target_pos)

func move_to(target_pos: Vector2):
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, move_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): moving = false)
