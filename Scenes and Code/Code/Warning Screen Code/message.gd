extends Label
var can_skip := true

var menu = preload("res://Scenes and Code/Scenes/title.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween_message("in") #Call the tween message function, with the fade in setting

func tween_message(fade: String):
	var tween = create_tween()
	
	if fade == "in": #If we are fading in
		#create and wait for a tween to finish that tweens the alpha of this node
		await tween.tween_property(self, "modulate:a", 1.0, 1.0).finished
		tween.kill()
		#Wait a sec
		await get_tree().create_timer(1.0).timeout
		#REcursively call this function, this time with the out setting
		tween_message("out")
	elif fade == "out": #if fading out
		#Do the opposite of in, fading the node out
		await tween.tween_property(self, "modulate:a", 0.0, 1.0).finished
		tween.kill()
		switch_to_main_menu() #then call the function that will switch the menu screen of the game

func switch_to_main_menu():
		get_tree().change_scene_to_packed(menu) #switch to the menu screen

func _input(event: InputEvent) -> void:
	#if the player presses the button mapped to the "skip_warning" command and the message currently can be skipped
	if event.is_action_pressed("skip_warning") and can_skip:
		can_skip == false #set can skip to false
		tween_message("out") #and call fade out early
