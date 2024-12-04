extends Camera2D

const maxCameraExtend = 200.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	extendCameraTowardsMouse()


func extendCameraTowardsMouse():
	var mousePos = get_local_mouse_position()/2.5
	
	var x = sign(mousePos.x)*min(abs(mousePos.x), maxCameraExtend)
	var y = sign(mousePos.y)*min(abs(mousePos.y), maxCameraExtend)
	position = Vector2(x, y)
