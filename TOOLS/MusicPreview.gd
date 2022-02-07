extends Spatial


onready var time_label = $Control/CenterContainer2/HBoxContainer/val
onready var track_label =  $Control/CenterContainer/HBoxContainer/val
onready var round_timer = $RoundTimer
onready var music_player = $MusicPlayer

func _on_MusicPlayer_track_set(track_name, index=null):
	if index == null:
		index = ""
	track_label.text = str(track_name, " ", index)


func _on_TickTimer_timeout():
	time_label.text = str(round_timer.time_left)
	#music_player.handle_time_tick(round_timer.time_left, true, false)
