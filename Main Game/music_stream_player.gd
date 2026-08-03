extends AudioStreamPlayer




func toggle_music():
	if stream_paused:
		stream_paused = true
	else:
		stream_paused = false
