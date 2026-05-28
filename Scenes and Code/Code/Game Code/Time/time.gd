extends Node2D

@export_group("Hour Times")
@export var first_hour : int = 90
@export var after_first_hour : int = 89

@onready var shift_timer: Timer = $"Shift Timer"
@onready var hour_label: Label = $"Hour Label"
@onready var six_am_screen: ColorRect = $"6AM Screen"
@onready var chime_sound: AudioStreamPlayer2D = $"Chime Sound"
@onready var cheer_sound: AudioStreamPlayer2D = $"Cheer Sound"

@onready var five_label : Label = $"6AM Screen/5"
@onready var six_label : Label = $"6AM Screen/6"
@onready var six_hider: ColorRect = $"6AM Screen/6 hider"
@onready var five_hider: ColorRect = $"6AM Screen/5 hider"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shift_timer.start(first_hour)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shift_timer_timeout() -> void:
	print("Next Hour")
	if Global.hour == 12:
		shift_timer.start(after_first_hour)
		Global.hour = 1
	elif Global.hour >= 1 and Global.hour < 5:
		shift_timer.start(after_first_hour)
		Global.hour += 1
	elif Global.hour == 5:
		win_and_sound_handler()
		six_am_screen.show()
		six_am_screen_tweening()
		Global.hour += 1
		print("You Win!!!")
	
	hour_label.text = str(Global.hour) + " AM"

func win_and_sound_handler():
	chime_sound.play()
	await get_tree().create_timer(6.45).timeout
	cheer_sound.play()
	
	await chime_sound.finished
	
	if Global.night < 5:
		Global.night += 1
	get_tree().change_scene_to_file("res://Scenes and Code/Scenes/title.tscn")


func six_am_screen_tweening():
	var tween = create_tween()
	var tweenhide5 = create_tween()
	var tweenhide6 = create_tween()
	var tweentext5 = create_tween()
	var tweentext6 = create_tween()
	
	tween.parallel().tween_property(six_am_screen, "color", Color.BLACK, 1.0)
	tweenhide5.parallel().tween_property(six_hider, "color", Color.BLACK, 1.0)
	tweenhide6.parallel().tween_property(five_hider, "color", Color.BLACK, 1.0)
	tweentext5.parallel().tween_property(five_label, "color", Color.WHITE, 1.0)
	tweentext6.parallel().tween_property(five_label, "color", Color.WHITE, 1.0)
	
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	
	five_to_six()

func five_to_six():
	var tween1 = create_tween()
	var tween2 = create_tween()
	var new_five_pos = Vector2(five_label.position.x, five_label.position.y - 90)
	var new_six_pos = Vector2(six_label.position.x, six_label.position.y - 90)
	
	#Move up by 90
	tween1.parallel().tween_property(five_label, "position", new_five_pos, 1.0)
	tween2.parallel().tween_property(six_label, "position", new_six_pos, 1.0)
	
	await tween1.finished
