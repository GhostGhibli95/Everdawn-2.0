extends CanvasLayer

var time_label
var day_label

func _ready():
	add_to_group("ui")
	
	time_label = $TimeLabel
	day_label = $TimeLabel/DayLabel

func update_time_display(time_string, day_string):
	time_label.text = time_string
	day_label.text = day_string
