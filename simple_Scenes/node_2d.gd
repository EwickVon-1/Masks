extends CharacterBody2D

@export var tile_size := 32
@export var move_time := 3

var CurrPos = [0,0]

var moving := false

var player = null
var player_chase = false
var speed = 32

	
func _physics_process(delta: float) -> void:
	wait(move_time)
	if player_chase:
			position.y += (player.position.y - position.y)
			position.x += (player.position.x - position.x)
			



func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player = body
	player_chase = true
	
	
	


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player = null
	player_chase = false
	
func wait(move_time: bool):
	await (get_tree().create_timer(move_time)).timeout
	return true
	
	
