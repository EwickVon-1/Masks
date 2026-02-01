extends AnimationPlayer

@onready var enemy = get_node("/root/LevelRoot/Enemy-01")
@onready var sprite = get_node("/root/LevelRoot/Enemy-01/Sprite2D")

var walkside = "left"

# Called when the node enters the scene tree for the first time.
func _ready():
	speed_scale = 4
	animation_finished.connect(_on_animation_finished)
	play("idle")
	
func _on_animation_finished(anim_name):
	if enemy.is_enemy_turn == false:
		speed_scale = 4
		play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy.directionfacing == "right":
		sprite.flip_h = false
		sprite.position.x = 10
	else:
		sprite.flip_h = true
		sprite.position.x = -10
	if not enemy.is_enemy_turn == false:
		speed_scale = 8
		play("run" + walkside)
		if walkside == "right":
			walkside = "left"
		else:
			walkside = "right"
