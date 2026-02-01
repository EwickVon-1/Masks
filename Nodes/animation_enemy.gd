extends AnimationPlayer

@onready var enemy = get_node("../../Enemy")
@onready var sprite = get_node("../Sprite2D")
var rundir = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_finished.connect(_on_animation_finished)
	speed_scale = 4
	play("idle") # Replace with function body.

func _on_animation_finished(anim_name):
	speed_scale = 4
	play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy.is_enemy_turn:
		speed_scale = 8
		play("run" + rundir)
		if rundir == "right":
			rundir = "left"
		else:
			rundir = "right"
		if enemy.dirfacing == "right":
			sprite.flip_h = false
		else:
			sprite.flip_h = true
			sprite.offset.x = 8
