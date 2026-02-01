extends StaticBody2D

var key_taken = false
var in_chest_zone = false

var chest = load("res://simple_Scenes/Chest.gd")

signal key_has_been_taken

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	if (key_taken == false):
			key_taken = true
			key_has_been_taken.emit()
			$Sprite2D.queue_free()
		

		
func _process(delta):
	if key_taken:
		if in_chest_zone:
			emit_signal("chest_oppened")
			print("chest is opened")
			

		
	
