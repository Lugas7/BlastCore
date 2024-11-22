extends Camera2D

const maxCameraExtend = 300.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	extendCameraTowardsMouse()


func extendCameraTowardsMouse():
	var mousePos = get_local_mouse_position()/4
	
	var left = -maxCameraExtend
	var right = maxCameraExtend
	var top = maxCameraExtend
	var bottom = -maxCameraExtend
	
	var x = sign(mousePos.x)*min(abs(mousePos.x), maxCameraExtend)
	var y = sign(mousePos.y)*min(abs(mousePos.y), maxCameraExtend)
	position = Vector2(clamp(x, left, right), clamp(y, bottom, top))
