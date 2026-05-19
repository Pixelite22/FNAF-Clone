extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.get_child(0).connect("timeout", _on_timer_timeout.bind(child.name))


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
				Global.bpos = ["BS", "WH"].pick_random()
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
					print("Jumpscared by Bonnie!")
					#This is being left here to not break this test build
					Global.bpos = "DH"
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
				Global.cpos = ["RR", "Kitchen"].pick_random()
			"RR":
				Global.cpos = ["Kitchen", "EH"].pick_random()
			"Kitchen":
				Global.cpos = ["RR", "EH"].pick_random()
			"EH":
				Global.cpos = ["DH", "EHC"].pick_random()
			"EHC":
				Global.cpos = ["EH", "blindspot"].pick_random() #BLINDSPOT PATH
			"blindspot":
				if Global.door_closed["Right"]:
					print("Chica Blocked!")
					Global.cpos = "DH"
				else:
					print("Jumpscared by Chica!")
					#This is being left here to not break this test build
					Global.cpos = "DH"
				#OFFICE OR DH DEPENDING ON DOOR PLACEMENT
		print("Chica moved to ", Global.cpos)

func fred_move():
	if randi_range(1, 20) <= Global.freddy_level:
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
				if Global.door_closed["Right"]:
					Global.fpos = "EH"
				else:
					print("Jumpscared by Freddy!")
					Global.fpos = "EH"
		print("Freddy moved to ", Global.fpos)

func fox_move():
	pass
