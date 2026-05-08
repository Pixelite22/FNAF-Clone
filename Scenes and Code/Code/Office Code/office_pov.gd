extends Camera2D

@export var max_x : float
@export var min_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += Global.office_pan * delta
	
	if position.x < min_x:
		position.x = min_x
	if position.x > max_x:
		position.x = max_x
