extends Node2D

@onready var blip_flash: AnimatedSprite2D = $"Blip Flash"
@onready var swap_sound: AudioStreamPlayer2D = $"Swap Sound"
@onready var location_names: AnimatedSprite2D = $"Location Names"

var cam_to_locations: Dictionary = {
	#Key/Camera : Location
	"Cam 1A" : "BS",
	"Cam 1B" : "SS",
	"Cam 1C" : "DH",
	"Cam 2A" : "WH",
	"Cam 2B" : "WHC",
	"Cam 3" : "SC",
	"Cam 4A" : "EH",
	"Cam 4B" : "EHC",
	"Cam 5" : "Pirate Cove",
	"Cam 6" : "Kitchen", #This is the disabled camera and will need to be handled later
	"Cam 7" : "RR"
}

var starting_room = "SS"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if "Cam" in child.name:
			child.get_child(0).connect("pressed", _on_button_pressed.bind(child))
			child.get_child(0).text = child.name.replace(" ", "\n").to_upper()
			if cam_to_locations[child.name] == starting_room:
				child.animation = "Selected"
				child.play()
			else:
				child.animation = "Unselected"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed(button_pressed : AnimatedSprite2D):
	for child in get_children():
		if "Cam" in child.name:
			if child.animation != "Unselected":
				child.animation = "Unselected"
	
	button_pressed.animation = "Selected"
	button_pressed.play()
	
	
	blip_flash.play()
	swap_sound.play()
	location_names.animation = cam_to_locations[button_pressed.name]
	Global.current_cam = cam_to_locations[button_pressed.name]
