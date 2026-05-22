extends AnimatedSprite2D

signal animatronic_moved_active_cam

var last_view
var anim_swap
var secret_or_progress : Dictionary = {
	"BS" : "secret",
	"BS b" : "secret",
	"DH b" : "progress",
	"DH c" : "progress",
	"EH" : "secret",
	"EH c" : "progress",
	"EHC" : "secret",
	"EHC c" : "secret",
	"Pirate Cove" : "progress",
	"RR c" : "secret",
	"WH" : "secret",
	"WHC" : "secret",
	"WHC b" : "secret"
}

var fox_running : bool = false
var run_anim_played : = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if fox_running and Global.current_cam == "WH":
		pass
	else:
		handle_view(Global.current_cam)

func handle_view(view : String):
	for animname in sprite_frames.get_animation_names():
		if animname == view:
			animation = animatronic_display(view)
			if anim_swap:
				if Global.current_cam == view and view != "Kitchen":
					print("Animation changed at ", view)
					animatronic_moved_active_cam.emit()
				frame = frame_selector(animation)



func animatronic_display(view : String):
	if view == "SS": #This if statement calls out the showstage specifically as it is the only area that can hold mulltiple animatronics
		if Global.fpos == view: #If freddy is in the room
			if Global.bpos == view: #and bonnie is
				if Global.cpos == view: #and chica is
					view += " b c f" #set view to the view and add the tags
				else: #if chica isn't here
					view += " b f" #set it to bonnie and freddies tags
			else: #If bonnie isn't here
				if Global.cpos == view: #but chica is
					view += " c f" #add chica and fred tags
				else: #but chica isn't
					view += " f" #set freddies tag only
		else: #If no one is here
			view = view #set view to itself
	elif view != "Kitchen": #if it isn't the show stage, we need to set it to chica overrides bon overrides fred
		if Global.cpos == view: #if chica is in view
			view += " c" #set the view to the chica tag
		elif Global.bpos == view: #but if she isn't and bonnie is
			view += " b" #set tag to bon
		elif Global.fpos == view: #and if both are missing but fred isn't
			view += " f" #Set fred's tag
		else: #and if all are gone, 
			view = view #set view to view
		view = view
	
	if view != animation: #if the view isn't actually the animation being shown
		anim_swap = true #set the animation swap boolean to true
	else: #otherwise
		anim_swap = false #set it to false
	
	return view #return the new view

#this will select the frame within the animation
func frame_selector(anim_name): 
	if anim_name in secret_or_progress:#if the animation is in the secret or progress dictionary
		if secret_or_progress[anim_name] == "secret": #And is a secret animation
			#var option = randi_range(0, 10)
			#print(option)
			#if option == 0:
			if randi_range(0, 10) == 0: #randomly select a number 0-10, and if the number is 0
				print("Rare screen reached!")
				return randi_range(1, sprite_frames.get_frame_count(anim_name)) #show a random secret screen within the animations library
			else: #if the number is anything but 0
				print("Normal Screen")
				return 0 #return the basic screen stored at frame 0
		else: #and if the animation isn't a secret
			if anim_name == "Pirate Cove":
				match Global.foxy_stage:
					1:
						return 0
					2:
						return 1
					3:
						return 2
					4:
						if randi_range(0, 10) == 0: #randomly select a number 0-10, and if the number is 0
							print("Rare screen reached!")
							return 4
						else:
							return 3
			elif " b" in anim_name:
				if Global.bprog == 1:
					return 0
				else:
					return 1
			elif " c" in anim_name:
				if Global.cprog == 1:
					return 0
				else:
					return 1
			else:
				return 0
	else: #and if the animation isn't in the dictionary at all
		return 0 #return the (most likely only) frame in the library


func _on_animatronic_ai_bprog_change() -> void:
	if " b" in animation:
		frame = frame_selector(animation)
		animatronic_moved_active_cam.emit()


func _on_animatronic_ai_cprog_change() -> void:
	if " c" in animation:
		frame = frame_selector(animation)
		animatronic_moved_active_cam.emit()

func _on_animatronic_ai_hall_run_play() -> void:
	print("Foxy hall run func reached")
	fox_running = true
	if animation == "WH":
		animation = "West Hall (Foxy Run)"
		play()
		run_anim_played = true
		await animation_finished
		stop()
