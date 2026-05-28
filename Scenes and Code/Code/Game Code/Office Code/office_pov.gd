extends Camera2D

@export var max_x : float
@export var min_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Add the office_pan multiplied by the delta to the position on the x axis
	position.x += Global.office_pan * delta
	
	#If the position being set is less then the minimum possible x
	if position.x < min_x:
		#set it to the minimum
		position.x = min_x
	#Same but with the maximum
	if position.x > max_x:
		position.x = max_x
