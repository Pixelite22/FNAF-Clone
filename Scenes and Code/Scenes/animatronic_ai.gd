extends Node2D

signal cprog_change
signal bprog_change
signal jumpscare(who)

var freddy_stage : int = 1
@onready var foxy_stall_timer: Timer = $"Foxy/Stall Timer"
var is_foxy_stalled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.get_child(0).connect("timeout", _on_timer_timeout.bind(child.name))
		if child.name == "Foxy":
			child.get_child(1).connect("timeout", _on_timer_timeout.bind(child.name + " stall timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout(whomst : String):
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
			"Office":
					jumpscare.emit("Bonnie")
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
				if Global.cprog == 1:
					Global.cpos = "EHC"
					Global.cprog += 1
					cprog_change.emit()
				else:
					Global.cpos = ["EH", "blindspot"].pick_random()
					Global.cprog -= 1
					cprog_change.emit()
			"blindspot":
				if Global.door_closed["Right"]:
					print("Chica Blocked!")
					Global.cpos = "DH"
				else:
					Global.cpos = "Office"
			"Office":
				jumpscare.emit("Chica")
				#OFFICE OR DH DEPENDING ON DOOR PLACEMENT
		print("Chica moved to ", Global.cpos)

func fred_move():
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
				"Office":
					jumpscare.emit("Freddy")
			print("Freddy moved to ", Global.fpos)
		else:
			print("Freddy was camera stalled")

func fox_move():
	if randi_range(1, 20) <= Global.foxy_level:
		if not is_foxy_stalled and not Global.camera_menu_active:
			if Global.foxy_stage < 3:
				print("Foxy Stage raised to: ", Global.foxy_level)
				Global.foxy_stage += 1
			elif Global.foxy_stage == 3:
				Global.foxy_stage += 1
				Global.foxpos = "West Hall (Foxy Run)"

func foxy_stall_timer_start(time):
	if not foxy_stall_timer.is_stopped():
		foxy_stall_timer.stop()
	foxy_stall_timer.start(time)
	is_foxy_stalled = true

func foxy_stall():
	print("Foxy no longer stalled")
	is_foxy_stalled = false
