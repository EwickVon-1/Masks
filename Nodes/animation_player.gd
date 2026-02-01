extends AnimationPlayer

@onready var player = get_node("../../Player")
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
	if player.action_committed:
		speed_scale = 8
		play("run" + rundir)
		if rundir == "right":
			rundir = "left"
		else:
			rundir = "right"
		if player.dirfacing == "right":
			sprite.flip_h = false
		else:
			sprite.flip_h = true
