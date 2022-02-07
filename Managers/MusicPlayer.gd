extends Node
signal track_set(track_name, index)
var music_pack:MusicPack
var music_pack_name
export (Resource) var track_to_load

onready var cur_track_player = $Current
onready var old_track_player = $Old #for crossfade stuff should i ever do this
onready var cache_audiostream = $CachePlayer

var tracklist
var current_track
var current_track_name
var loop_index = 0
var looping = false
var loop_order = []
var outro_track_start_time:int = 30
var outro_called = false
var is_playing = false

func _ready():
	_set_music_pack()


#FUNCTION THAT LOADS/INITS MUSIC PACKS
func _set_music_pack():
		load_musicpack(track_to_load)

func load_musicpack(_music_pack:MusicPack, cache_list:bool=true):
		var packinfo = [_music_pack, "doesnt_matter"]
		var mus_pack = packinfo[0]
		var mus_pack_name = packinfo[1]
		
		if mus_pack != music_pack:
			loop_order = [] #reset loop order before applying new
			music_pack_name = mus_pack_name
			music_pack = mus_pack
			tracklist = {"intro":var2str(music_pack.intro),"outro":var2str(music_pack.outro),"loops":var2str(music_pack.loops)}
			outro_track_start_time = music_pack.play_outro_track_at
			if music_pack.custom_loop_order != []:
				loop_order = music_pack.custom_loop_order
			else:
				var loop_count = 0 #default to loop 1, 2, 3..
				for i in str2var(tracklist["loops"]):
					loop_order.append(loop_count)
					loop_count += 1
			
			if cache_list:
				for i in tracklist.keys(): #is this necessary? we will see
					var temp = str2var(tracklist[i])
					if typeof(temp) == TYPE_ARRAY:
						for v in temp:
							cache_audiostream.stream = v
							cache_audiostream.play()
					else:
						cache_audiostream.stream = temp
						cache_audiostream.play()
				cache_audiostream.stop()
				print("Music cached")


#TRACK PLAYING/LOOPING ETC.
func play_music(track_to_play, offset=0, is_loop=false):
	if music_pack != null:
		#print("Track received: ", track_to_play)
		
		var next_track
		if track_to_play is String:
			if track_to_play == "loops":
				next_track = get_track(track_to_play, loop_order[loop_index])
			else:
				next_track = get_track(track_to_play)
		else:
			push_error("Received track file instead of track name")
			return
			#next_track = track_to_play
			
		if next_track != current_track:
			stop_all_tracks()
			#print("Playing track ", next_track)
			current_track = next_track
			current_track_name = track_to_play
			cur_track_player.stream = next_track
			cur_track_player.play(offset)
			is_playing = true
			var loop_index_for_text_preview = loop_index
			if track_to_play == "loops":
				 loop_index_for_text_preview = loop_index
			else:
				loop_index_for_text_preview = null
			emit_signal("track_set", current_track_name, loop_index_for_text_preview)

func stop_all_tracks(reset_values=false):
	cur_track_player.stop()
	old_track_player.stop()
	if reset_values:
		looping = false
		is_playing = false
		outro_called = false
		loop_index = 0

func queue_loops():
	if music_pack.loops.size() < 1: #don't loop if there is no loops
		is_playing = false
		return
	looping = true
	handle_looping()
		
func handle_looping():
	if !looping or outro_called:
		return
	#print("Trying to play loop ", loop_index)
	if !outro_called and looping:
		play_music("loops")
		loop_index += 1
	if loop_index >= loop_order.size():
		loop_index = 0
	#if loop_index >= music_pack.loops.size():
		#loop_index = 0

func round_start():
	looping = false
	is_playing = false
	outro_called = false
	loop_index = 0
	play_music("intro")
	
func round_ending(offset=0):
	play_music("outro", offset)
	looping = false
	outro_called = true
	
func handle_time_tick(time_left, match_started, match_finished):
	if match_started and is_playing:
		if time_left <= outro_track_start_time and !outro_called:
			var track_length = current_track.get_length()
			var offset = time_left - outro_track_start_time

			if offset < 0:
				round_ending(abs(offset))
			else:
				round_ending()
	else:
		if !match_finished and !is_playing:
			round_start()



#MUSIC NETWORK SYNCING
func get_current_track():
	return [music_pack_name, [current_track_name, cur_track_player.get_playback_position(), looping, loop_index, outro_called, is_playing]]

#SETTER/GETTERS

func get_track(trackname, index=null):
	#print("get track: ", trackname)
	var track
	var trackvar = str2var(trackname)
	if music_pack:
		if index == null:
			track = str2var(tracklist.get(trackvar))#music_pack.trackvar
		else:
			track = str2var(tracklist.get(trackvar))[index]
			
	if track:
		#print("returning track ", track)
		return track


#CALLBACKS
func _on_MatchStarting_finished():
	if outro_called:
		stop_all_tracks()
	else:
		queue_loops()
