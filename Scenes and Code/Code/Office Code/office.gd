extends Node2D

#Office Background Nodes
@onready var officeBG: AnimatedSprite2D = $OfficeBG
@onready var left_side: AnimatedSprite2D = $"OfficeBG/Left Side"
@onready var right_side: AnimatedSprite2D = $"OfficeBG/Right Side"
@onready var light_sound: AudioStreamPlayer2D = $"OfficeBG/Light Sound"
@onready var fan: AnimatedSprite2D = $OfficeBG/Fan
@onready var jumpscare_sound: AudioStreamPlayer2D = $"OfficeBG/Jumpscare Sound"
@onready var kill_timer: Timer = $"OfficeBG/Kill Timer"


#Button Nodes for doors and lights
@onready var left_buttons: AnimatedSprite2D = $"Left Buttons"
@onready var right_buttons: AnimatedSprite2D = $"Right Buttons"
@onready var blindspot_stinger_r: AudioStreamPlayer2D = $"Left Buttons/Blindspot Stinger"
@onready var blindspot_stinger_l: AudioStreamPlayer2D = $"Right Buttons/Blindspot Stinger"

#Nodes for the doors
@onready var right_door: AnimatedSprite2D = $"Right Door"
@onready var left_door: AnimatedSprite2D = $"Left Door"
@onready var door_sound_l: AudioStreamPlayer2D = $"Left Door/Door Sound"
@onready var door_sound_r: AudioStreamPlayer2D = $"Right Door/Door Sound"
@onready var foxy_knock: AudioStreamPlayer2D = $"Left Door/Foxy Knock"

#GUI nodes
@onready var gui: CanvasLayer = $GUI
@onready var cam_arrow: TextureRect = $"GUI/Cam Arrow"
@onready var cam_collision_shape: CollisionShape2D = $"GUI/Cam Arrow/Cam Collision/CollisionShape2D"
@onready var cam_collision: Area2D = $"GUI/Cam Arrow/Cam Collision"
@onready var camera_panel: AnimatedSprite2D = $"GUI/Camera Panel"
@onready var camera_sound: AudioStreamPlayer2D = $"GUI/Camera Panel/Camera Sound"

#Nodes on the camera, including the in game camera system
@onready var camera_menu: AnimatedSprite2D = $"Camera2D/Camera System/Camera View"
@onready var animation_player: AnimationPlayer = $"Camera2D/Camera System/Camera View/AnimationPlayer"
@onready var camera_2d: Camera2D = $Camera2D
@onready var camstatic: AnimatedSprite2D = $"Camera2D/Camera System/Camera Effects/Static"
@onready var camera_system: Node2D = $"Camera2D/Camera System"
@onready var camera_effects: CanvasLayer = $"Camera2D/Camera System/Camera Effects"

#Node for handling Animatronic AI
@onready var animatronic_ai: Node2D = $"Animatronic AI"

#More Generic variables
var in_office : String
var stinger_played_l : bool = false
var stinger_played_r : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect the door change and lights on signals from the left and right switch buttons
	left_buttons.connect("door_change", office_door_sprite_call)
	right_buttons.connect("door_change", office_door_sprite_call)
	left_buttons.connect("lights_on", light_sound_handler)
	right_buttons.connect("lights_on", light_sound_handler)
	left_side.connect("frame_changed", on_frame_changed.bind(left_side))
	right_side.connect("frame_changed", on_frame_changed.bind(right_side))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#call the sprite call every frame to ensure the lights are displaying correctly
	office_lights_sprite_call()
	

func office_door_sprite_call(door_open, button_pressed):
	#find whether the left or right door button has been pressed 
	#and set the variable to just include the name 
	if "Left" in button_pressed:
		button_pressed = "Left"
	elif "Right" in button_pressed:
		button_pressed = "Right"
	
	#define an array to hold the passed info, that being whether or not the door is currently open, and which side we are targeting
	var door_target = [door_open, button_pressed]
	
	#Now match this array to the possible states
	match door_target:
		#Each of these does the same thing with slight differences and as such will be shown with an example case here explaining each line
		#[Case to match the array to]
			#play the sound of the correct door
			#play the opening animation either forward or backward to show the door open or close
			#wait for the animation to finish
			#then play the open or closed animation for the door dependent on case
			#then update the door closed array defined in the global script so other parts of the game can check this
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
			
	
	#Checks the global variables so we can make sure the doors are both playing and recorded correctly in our system
	print("Left door is closed? " + str(Global.door_closed["Left"]))
	print("Right door is closed? " + str(Global.door_closed["Right"]))


func office_lights_sprite_call():
	var flicker_chance = randi_range(1, 10)
	
	#simple function for keeping the office lights updated based on the light pressed
	#if side has light pressed, light that side, if it doesn't then dont
	if left_buttons.light_pressed and flicker_chance != 1:
		if Global.fpos == "blindspot":
			left_side.frame = 3
		elif Global.bpos == "blindspot":
			left_side.frame = 2
		else:
			left_side.frame = 1
	else:
		left_side.frame = 0
	
	if right_buttons.light_pressed and flicker_chance != 1:
		if Global.cpos == "blindspot":
			right_side.frame = 2
		else:
			right_side.frame = 1
	else:
		right_side.frame = 0

func light_sound_handler(on):
	#function to handle the light sound effect playing
	#if the function is called when the light turns on and the sound isn't already playing,
	if on and not light_sound.playing:
		#play the sound
		light_sound.play()
	#If the function is called when turning the light off, and neither of the buttons are currently pressed
	elif not on and ((not right_buttons.light_pressed) and (not left_buttons.light_pressed)):
		#stop the sound
		light_sound.stop()


#This function handles the calling up and pulling down of the camera panel
func _on_cam_collision_mouse_entered() -> void:
	#This first if-else tree handles assigning the actual active signal, swaping whether it is true or false as needed
	#if the camera_panel's animation is finished
	if camera_panel.animation_finished:
		#and the camera_menu_active variable in the global script is true
		if Global.camera_menu_active:
			#set that variable to false
			Global.camera_menu_active = false
			#Global.foxy_stalled = randf_range(0.83, 17.5)
			animatronic_ai.foxy_stall_timer_start(randf_range(0.83, 17.5))
		elif not Global.camera_menu_active: #but if it was false, set it to true
			Global.camera_menu_active = true
	
	#call the camera handler to ACTUALLY handle the camera
	#pass the variable in so the function knows whether the camera is meant to be going up or down
	camera_handler(Global.camera_menu_active)
	#print message to ensure things are lining up as they should
	print("Camera Menu Active? ", str(Global.camera_menu_active))

func camera_handler(putting_up):
	#call the sound function so the sound plays
	camera_sound_handler()
	
	var jumpscare_possibility = in_office
	
	#if the camera is going up
	if putting_up:
		#show the camera panel and play the animation
		camera_panel.show()
		camera_panel.play()
		#wait for the animation to finish, and then wait another 0.3 seconds to ensure this isn't too abrupt
		await camera_panel.animation_finished
		await get_tree().create_timer(0.3).timeout
		#then if the camera_menu_active variable is true, meaning the camera menu should be up
		if Global.camera_menu_active:
			##Might be worth tweening this so it looks like a TV turning on and lower down, tweening it off
			#hide the panel and show the menu
			camera_panel.hide()
			animation_player.play("Cam_Pan")
			if not camera_system.visible:
				camera_system.show()
				camera_effects.show()
		#Allow secret frames a chance to change
		if camera_menu.sprite_frames.get_frame_count(camera_menu.animation) > 1:
			camera_menu.frame = camera_menu.frame_selector(camera_menu.animation)
		
		if in_office != "":
			kill_timer.start(randf_range(20.0, 30.0))
		
		if Global.foxpos == "West Hall (Foxy Run)" and Global.current_cam == "WH":
			camera_menu._on_camera_ui_fox_on_the_run()
			Global.fox_run_checked = true
	
	#but if we aren't putting the camera up
	elif not putting_up:
		animation_player.stop()
		#show the panel and hide the menu, then play the panel animation backwards
		camera_panel.show()
		if camera_system.visible:
			camera_system.hide()
			camera_effects.hide()
		camera_panel.play_backwards()
		#then wait for the animation to finish and hide the panel
		
		await camera_panel.animation_finished
		camera_panel.hide()
		if jumpscare_possibility != "" and not Global.jumpscared:
			jumpscare_handler(jumpscare_possibility)


func camera_sound_handler():
	#play camera sound, wait a second, and then stop the camera sound
	camera_sound.play()
	await get_tree().create_timer(1.0).timeout
	camera_sound.stop()

func _on_animatronic_ai_in_office(who: Variant) -> void:
	if in_office == "":
		in_office = who
		if Global.camera_menu_active:
			kill_timer.start(randf_range(20.0, 30.0))
	
	if who == "Bonnie":
		left_buttons.disconnect_door_button()
	if who == "Chica":
		right_buttons.disconnect_door_button()
	if who == "Freddy":
		right_buttons.disconnect_door_button()
		fred_handler()

func fred_handler():
	if randi_range(1, 4) == 1:
		jumpscare_handler("Freddy")
	else:
		await get_tree().create_timer(1.0).timeout
		fred_handler()

func jumpscare_handler(whomstve):
	Global.jumpscared = true
	if Global.camera_menu_active:
		camera_handler(false)
	fan.hide()
	left_side.hide()
	right_side.hide()
	light_sound.stop()
	right_door.hide()
	left_door.hide()
	gui.hide()
	camera_system.hide()
	camera_effects.hide()
	left_buttons.door_no_more()
	right_buttons.door_no_more()
	
	if whomstve == "Foxy":
		camera_2d.position.x = 0
	else:
		camera_2d.position.x = ((1600/2)-(1200/2))
	
	
	officeBG.animation = whomstve + " Jumpscare"
	print("Jumpscared by ", whomstve)
	officeBG.play()
	jumpscare_sound.play()


func _on_kill_timer_timeout() -> void:
	if not Global.jumpscared:
		jumpscare_handler(in_office)


func _on_foxy_repel() -> void:
	#add sound effects and power options
	foxy_knock.play()
	Global.foxpos = "Pirate Cove"
	Global.foxy_stage = 1
	Global.fox_on_the_run = false


func jump_or_repel_fox() -> void:
	if Global.door_closed["Left"] == false:
		jumpscare_handler("Foxy")
	else:
		_on_foxy_repel()


func on_frame_changed(side : AnimatedSprite2D) -> void:
	if "Left" in side.name:
		if side.frame == 2 and Global.bpos != "Office":
			if not stinger_played_l:
				blindspot_stinger_l.play()
				stinger_played_l = true
		elif side.frame == 1:
			stinger_played_l = false
	
	elif "Right" in side.name:
		if side.frame == 2 and Global.bpos != "Office":
			if not stinger_played_r:
				blindspot_stinger_r.play()
				stinger_played_r = true
		elif side.frame == 1:
			stinger_played_r = false
