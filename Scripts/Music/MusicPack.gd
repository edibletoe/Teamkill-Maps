class_name MusicPack
export (String) var track_author = "" #likely to go unused
export var intro: AudioStream
export var outro: AudioStream
export var post_match: AudioStream
export (Array, AudioStream) var loops
export (int) var play_outro_track_at = 30 #to add variable length to end tracks, int is seconds remaining in match
export (Array , int) var custom_loop_order = [] #use this to define what indices to play in sequence
