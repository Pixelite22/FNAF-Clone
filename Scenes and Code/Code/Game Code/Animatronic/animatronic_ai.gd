extends Node2D

signal cprog_change
signal bprog_change
signal in_office(who)
signal hall_run_play
signal jump_or_repel_fox


@onready var btimer: Timer = $Bonnie/Timer
@onready var ctimer: Timer = $Chica/Timer
@onready var ftimer: Timer = $Freddy/Timer
#Foxy nodes
@onready var foxtimer: Timer = $Foxy/Timer
@onready var foxy_stall_timer: Timer = $"Foxy/Stall Timer"
@onready var foxy_kill_timer: Timer = $"Foxy/Kill Timer"
@onready var foxy_run: AudioStreamPlayer2D = $"Foxy/Foxy Run"


var freddy_stage : int = 1
var is_foxy_stalled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect the timeout of all the timers on each animatronic to the timer timeout function
	for child in get_children():
		child.get_child(0).connect("timeout", _on_timer_timeout.bind(child.name))
		#If the child is foxy, make sure to also add the timeout for the stall timer
		if child.name == "Foxy":
			child.get_child(1).connect("timeout", _on_timer_timeout.bind(child.name + " stall timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#When one of the animatronic move timers times out, call this function
func _on_timer_timeout(whomst : String):
	#Match whichever animatronic called this function to the proper movement (or stall in foxy's case) function
	match whomst:
		"Bonnie":
			bon_move()
		"Chica":
			chi_move()
		"Freddy":
			fred_move()
		"Foxy":
			fox_move()
		"Foxy stall timeout":
			foxy_stall()


#Bonnie has the most freedom of movement, having essentially two possible next steps at any given moment
#SS : BS or DH
#DH : BS or WH
#BS : DH or WH
#SC : blindspot or WH
#WH : SC or WHC
#WHC : SC or blindspot
#blindspot : into office or DH
func bon_move():
	#The following lines is essentially the entire AI of Bonnie
	#if a randomly chosen number between and including 1 and 20 is greater then the set level of Bonnie's AI
	#Then have Bonnie move, the location to dependent on where he currently is.  The Comment above the function shows the possible movements from any given position
	if randi_range(1, 20) <= Global.bonnie_level:
		match Global.bpos:
			"SS":
				Global.bpos = ["BS", "DH"].pick_random()
			"DH":
				if Global.bprog == 1:
					Global.bpos = "DH"
					Global.bprog += 1
					bprog_change.emit()
				else:
					Global.bpos = ["BS", "WH"].pick_random()
					Global.bprog -= 1
					bprog_change.emit()
			"BS":
				Global.bpos = ["DH", "WH"].pick_random()
			"SC":
				Global.bpos = ["WH", "blindspot"].pick_random() #CAN GO INTO BLINDSPOT HERE TOO
			"WH":
				Global.bpos = ["SC", "WHC"].pick_random()
			"WHC":
				Global.bpos = ["SC", "blindspot"].pick_random() #CAN GO INTO BLINDSPOT HERE TOO
			"blindspot":
				if Global.door_closed["Left"]:
					print("Bonnie Blocked!")
					Global.bpos = "DH"
				else:
					Global.bpos = "Office"
					in_office.emit("Bonnie")
					btimer.stop()
		print("Bonnie moved to ", Global.bpos)


#I am bundling chica and freddie together because they follow the same path.
#They also work fairly similarly I am pretty sure?
#SS : DH
#DH : RR or Kitchen
#RR : Kitchen or EH
#Kitchen : RR or EH
#EH : DH or EHC
#EHC : blindspot or EH
#blindspot : Office or DH
func chi_move():
	#The following lines is essentially the entire AI of Chica
	#if a randomly chosen number between and including 1 and 20 is greater then the set level of Chica's AI
	#Then have Chica move, the location to dependent on where she currently is.  The Comment above the function shows the possible movements from any given position
	if randi_range(1, 20) <= Global.chica_level:
		match Global.cpos:
			"SS":
				Global.cpos = ["DH"].pick_random()
			"DH":
				if Global.cprog == 1:
					Global.cpos = "DH"
					Global.cprog += 1
					cprog_change.emit()
				else:
					Global.cpos = ["RR", "Kitchen"].pick_random()
					Global.cprog -= 1
					cprog_change.emit()
			"RR":
				Global.cpos = ["Kitchen", "EH"].pick_random()
			"Kitchen":
				Global.cpos = ["RR", "EH"].pick_random()
			"EH":
				if Global.cprog == 1:
					Global.cpos = "EH"
					Global.cprog += 1
					cprog_change.emit()
				else:
					Global.cpos = ["DH", "EHC"].pick_random()
					Global.cprog -= 1
					cprog_change.emit()
			"EHC":
				Global.cpos = ["EH", "blindspot"].pick_random()
			"blindspot":
				if Global.door_closed["Right"]:
					print("Chica Blocked!")
					Global.cpos = "DH"
				else:
					Global.cpos = "Office"
					in_office.emit("Chica")
					ctimer.stop()

		print("Chica moved to ", Global.cpos)

func fred_move():
	#The following lines is essentially the entire AI of Fred
	#if a randomly chosen number between and including 1 and 20 is greater then the set level of Freddie's AI
	#Then have Freddy move, the location to dependent on where he currently is.  The map is the same as Chica but he will never move backwards
	#He also doesn't reset to the dining hall, but instead to the hallway.
	if randi_range(1, 20) <= Global.freddy_level and (Global.bpos != "SS" and Global.cpos != "SS"):
		if freddy_stage == 1 or (freddy_stage == 2 and not Global.current_cam == Global.fpos):
			match Global.fpos:
				"SS":
					Global.fpos = "DH"
				"DH":
					Global.fpos = "RR"
				"RR":
					Global.fpos = "Kitchen"
				"Kitchen":
					Global.fpos = "EH"
				"EH":
					Global.fpos = "EHC"
				"EHC":
					freddy_stage = 2
					if Global.door_closed["Right"]:
						Global.fpos = "EH"
					else:
						Global.fpos = "Office"
						in_office.emit("Freddy")
						ftimer.stop()
			
			print("Freddy moved to ", Global.fpos)
		else:
			print("Freddy was camera stalled")

func fox_move():
	#Foxy AI is detailed here
	#Essentially, instead of moving, his stage increases.  At stage 4, he runs for the office
	#Since this is the most complicated of the AI, I am going to overly comment it
	#The if check for ai level stays the same
	if randi_range(1, 20) <= Global.foxy_level:
		#Now we make sure foxy isn't stalled, the camera isn't active, and he isn't currently running to the office.
		#if any of these are true, foxy can't increase stage
		if not is_foxy_stalled and not Global.camera_menu_active and not Global.fox_on_the_run:
			#If foxy is less the stage 3 when this function is called
			if Global.foxy_stage < 3:
				#Just raise him by one stage
				print("Foxy Stage raised to: ", Global.foxy_stage)
				Global.foxy_stage += 1
			#However if he is on stage 3
			elif Global.foxy_stage == 3:
				#increase him to 4
				Global.foxy_stage += 1
				#set the variable tracking if foxy is running to true
				Global.fox_on_the_run = true
				#emit the signal to tell the rest of the program that he is ready to run
				hall_run_play.emit()
				#set his position to the west hall foxy run animation
				Global.foxpos = "West Hall (Foxy Run)"
				#Start the kill timer with a value between 2 (near instant) and 25 (classic FNAF)
				foxy_kill_timer.start(randf_range(2, 25))
				#and when it timeouts
				await foxy_kill_timer.timeout
				#play the foxy run audio
				foxy_run.play()
				#wait for the audio to end
				await foxy_run.finished
				print("Foxy kill timer time out")
				#then call the jump or repel function to determine if foxy is jumpscaring or going back to stage 1
				jump_or_repel_fox.emit()

#function for the stall timer, taking the time it should run as a member
func foxy_stall_timer_start(time):
	#if foxy isn't already running
	if not Global.fox_on_the_run:
		#and if the stall timer isn't stopped
		if not foxy_stall_timer.is_stopped():
			#stop the timer
			foxy_stall_timer.stop()
		#Start the timer with the new time
		foxy_stall_timer.start(time)
		#and set the stalled flag to true
		is_foxy_stalled = true

#the stall timer's timeout
func foxy_stall():
	print("Foxy no longer stalled")
	is_foxy_stalled = false

#this function is called when it recieves a signal from the camera view node
#it just stops the kill timer when needed
func _on_camera_view_stop_foxy_kill_timer() -> void:
	print("Foxy Kill Timer stopped")
	foxy_kill_timer.stop()
