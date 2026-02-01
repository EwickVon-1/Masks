extends AnimationPlayer

@onready var player = get_node("/root/LevelRoot/Player")
@onready var sprite = get_node("/root/LevelRoot/Player/Sprite2D2")

var walkside = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	speed_scale = 4
	animation_finished.connect(_on_animation_finished)
	play("idle")
	
func _on_animation_finished(anim_name):
	if player.action_committed == false:
		speed_scale = 4
		play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.directionfacing == "right":
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	if not player.action_committed == false:
		speed_scale = 8
		play("run" + walkside)
		if walkside == "right":
			walkside = "left"
		else:
			walkside = "right"
