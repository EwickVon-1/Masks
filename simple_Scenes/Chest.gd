extends StaticBody2D
var DA_key_aqquired = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func key_has_been_taken():
	print("Got signal")
	DA_key_aqquired = true
	
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if DA_key_aqquired:
		print("Next Level") #emmit next level
		
