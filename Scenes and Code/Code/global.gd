extends Node

#Define a global check for the left and right doors
var door_closed = {
	"Left" : false,
	"Right" : false
}
#and one for whether the camera menu is up
var camera_menu_active : bool = false
#And one for the pan speed of the office
var office_pan = 0



var possible_cam

@export_group("Camera Settings")
@export var current_cam = "SS"
@export var fpos = "SS"
@export var bpos = "SS"
@export var cpos = "SS"
@export var foxpos = "Pirate Cove"

@export_group("Animatronic AI Level")
@export var bonnie_level : int = 20
@export var chica_level : int = 20
@export var freddy_level : int = 10
@export var foxy_level : int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Make sure this script is always run so pauses to the game don't brake it

func _input(event: InputEvent) -> void:
	if event is InputEventKey: #If the player gives an input involving a key on keyboard
		if event.pressed: #If the key was pressed
			if event.keycode == KEY_ESCAPE: #If the key pressed was escape
				get_tree().quit() #Quit the game
			if event.keycode == KEY_F11: #but if the key was f11
				if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN: #if the screen is in fullscreen mode
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) #set the mode to windowed
					DisplayServer.window_set_size(Vector2i(1152, 648)) #Set the size to the needed size to run the game
					DisplayServer.window_set_position(Vector2i(int((DisplayServer.screen_get_size().x/2.0)-(DisplayServer.window_get_size().x/2.0)),int((DisplayServer.screen_get_size().y/2.0)-(DisplayServer.window_get_size().y/2.0)))) #and set the screen position to the middle of the screen
				else: #If it isn't fullscreen though
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN) #make it full screen
