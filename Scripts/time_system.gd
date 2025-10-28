extends Node2D

var time_scale = 1.0
var minutes_per_day = 1440
var game_minutes_per_real_second = 60

var current_day = 1
var current_hour = 6
var current_minute = 0

var days_of_week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
var current_day_of_week = 0

var time_elapsed = 0.0

func _ready() -> void:
	add_to_group("time_system")
	
func _process(delta: float) -> void:
	time_elapsed += delta * time_scale
	
	if time_elapsed >= (1.0 / game_minutes_per_real_second):
		time_elapsed = 0.0
		advance_time()
		
func advance_time():
	current_minute += 1
	
	if current_minute >= 60:
		current_minute = 0
		current_hour += 1
		
	if current_hour >= 24:
		current_hour = 0
		current_day += 1
		current_day_of_week = (current_day_of_week + 1) % 7
		
	update_ui()
	
func update_ui():
	var time_string = get_time_string()
	var day_string = get_day_string()
	get_tree().call_group("ui", "update_time_display", time_string, day_string)
	
func get_time_string() -> String:
	var period = "AM"
	var display_hour = current_hour
	
	if current_hour >= 12:
		period = "PM"
		if current_hour > 12:
			display_hour = current_hour - 12
	if current_hour == 0:
		display_hour = 12

	return "%d:%02d %s" % [display_hour, current_minute, period]
	
	
func get_day_string() -> String:
	return "%s, Day %d" % [days_of_week[current_day_of_week], current_day]
