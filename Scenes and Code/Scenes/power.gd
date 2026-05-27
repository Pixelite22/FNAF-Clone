extends Node2D

@onready var power_left: Sprite2D = $PowerLeft
@onready var power_display: RichTextLabel = $"Power Display"
@onready var usage: Sprite2D = $Usage
@onready var battery: AnimatedSprite2D = $Battery
@onready var timer: Timer = $"Power Display/Timer"

func _ready() -> void:
	power_consumption_setting()

func _process(delta: float) -> void:
	battery.frame = Global.usage - 1

func power_consumption_setting():
	if Global.night == 1:
		timer.wait_time = 6
	if Global.night == 2:
		timer.wait_time = 5
	if Global.night == 3:
		timer.wait_time = 4
	if Global.night >= 4:
		timer.wait_time = 3

func _on_timer_timeout() -> void:
	if Global.power > 0:
		Global.power -= Global.usage
		power_display_handler()

func power_display_handler():
	power_display.text = str(int(round(Global.power / 10))) + "%"
