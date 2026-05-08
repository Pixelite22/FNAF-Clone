extends AnimatedSprite2D

var door_pressed : bool = false
var light_pressed : bool = false

signal door_change(door_state, name_of_switch)
signal lights_on(is_it)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in get_children():
		if "Door" in button.name:
			button.connect("pressed", door_button_pressed)
		elif "Light" in button.name:
			button.connect("pressed", light_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func light_switch_sprite():
	var frame_number
	var press_check = [door_pressed, light_pressed]
	match press_check:
		[false, false]:
			frame_number = 0
		[true, false]:
			frame_number = 1
		[false, true]:
			frame_number = 2
		[true, true]:
			frame_number = 3
	
	return frame_number

func door_button_pressed():
	if not door_pressed:
		door_pressed = true
	elif door_pressed:
		door_pressed = false
	
	door_change.emit(door_pressed, self.name)
	
	print(door_pressed)
	
	frame = light_switch_sprite()
	

func light_button_pressed():
	if not light_pressed:
		light_pressed = true
	elif light_pressed:
		light_pressed = false
	
	frame = light_switch_sprite()
	lights_on.emit(light_pressed)
