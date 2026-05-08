extends Node2D

@onready var officeBG: AnimatedSprite2D = $OfficeBG
@onready var left_side: AnimatedSprite2D = $"OfficeBG/Left Side"
@onready var right_side: AnimatedSprite2D = $"OfficeBG/Right Side"
@onready var light_sound: AudioStreamPlayer2D = $"OfficeBG/Light Sound"
@onready var left_buttons: AnimatedSprite2D = $"Left Buttons"
@onready var right_buttons: AnimatedSprite2D = $"Right Buttons"
@onready var right_door: AnimatedSprite2D = $"Right Door"
@onready var left_door: AnimatedSprite2D = $"Left Door"
@onready var door_sound_l: AudioStreamPlayer2D = $"Left Door/Door Sound"
@onready var door_sound_r: AudioStreamPlayer2D = $"Right Door/Door Sound"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_buttons.connect("door_change", office_door_sprite_call)
	right_buttons.connect("door_change", office_door_sprite_call)
	left_buttons.connect("lights_on", light_sound_handler)
	right_buttons.connect("lights_on", light_sound_handler)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	office_lights_sprite_call()

func office_door_sprite_call(door_open, button_pressed):
	if "Left" in button_pressed:
		button_pressed = "Left"
	elif "Right" in button_pressed:
		button_pressed = "Right"
	
	var door_target = [door_open, button_pressed]
	
	match door_target:
		[false, "Left"]: #Left Opening
			door_sound_l.play()
			left_door.play("Opening")
			await left_door.animation_finished
			left_door.play("Open")
			Global.door_closed["Left"] = false
		[false, "Right"]: #Right Opening
			door_sound_r.play()
			right_door.play("Opening")
			await right_door.animation_finished
			right_door.play("Open")
			Global.door_closed["Right"] = false
		[true, "Left"]: #Left closing
			door_sound_l.play()
			left_door.play_backwards("Opening")
			await left_door.animation_finished
			left_door.play("Close")
			Global.door_closed["Left"] = true
		[true, "Right"]: #Right closing
			door_sound_r.play()
			right_door.play_backwards("Opening")
			await right_door.animation_finished
			right_door.play("Close")
			Global.door_closed["Right"] = true
			
	
	print("Left door is closed? " + str(Global.door_closed["Left"]))
	print("Right door is closed? " + str(Global.door_closed["Right"]))

func office_lights_sprite_call():
	if left_buttons.light_pressed:
		left_side.frame = 1
	else:
		left_side.frame = 0
	
	if right_buttons.light_pressed:
		right_side.frame = 1
	else:
		right_side.frame = 0

func light_sound_handler(on):
	if on and not light_sound.playing:
		light_sound.play()
	elif not on and ((not right_buttons.light_pressed) and (not left_buttons.light_pressed)):
		light_sound.stop()
