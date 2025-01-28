/*
/proc/stationtime2text(format = "hh:mm:ss", reference_time = world.time)
	return time2text(station_time(reference_time), format, 0)
*/
/client/proc/show_location_blurb(duration = 3 SECONDS, var/write_time=1, var/write_sound_volume=25, var/write_sound, var/space_delay, var/space_sound_volume=10, var/space_sound, var/new_line_delay, var/new_line_sound_volume=45, var/new_line_sound, var/ignore_new_lines, var/ignore_spaces, var/text)
	set waitfor = FALSE

	var/style = "text-align: left; vertical-align:'top'; font-family: 'Javanese Text'; -dm-text-outline: 1 black; font-size: 12px; "
	text = uppertext(text)

	var/atom/movable/screen/T = new /atom/movable/screen{
		maptext_height = 64;
		maptext_width = 512;
		layer = FLOAT_LAYER;
		plane = HUD_PLANE;
		appearance_flags = APPEARANCE_UI_IGNORE_ALPHA;
		screen_loc = "LEFT+6,BOTTOM+0.25";
		alpha = 0;
	}

	var/mob/M = src.mob

	screen += T
	animate(T, alpha = 255, time = 10)
	for(var/i = 1 to length_char(text) + 1)
		T.maptext = "<span style=\"[style]\">[copytext_char(text, 1, i)] </span>"
		var/soundplayed = FALSE
		var/char = copytext_char(text, i-1, i)
		if(char == "\n") // for some reason using "char == "" or "\n" won't work.."
			if(ignore_new_lines)
				soundplayed = TRUE
			if(new_line_sound)
				if(!soundplayed)
					M.playsound_local(M, list('sound/effects/typewriter/end1.ogg', 'sound/effects/typewriter/end2.ogg'), new_line_sound_volume, FALSE)
					soundplayed = TRUE
					sleep(new_line_delay)
		else if(char == " ")
			if(ignore_spaces)
				soundplayed = TRUE
			if(space_sound)
				if(!soundplayed)
					M.playsound_local(M, list('sound/effects/typewriter/space1.ogg', 'sound/effects/typewriter/space2.ogg'), space_sound_volume, FALSE)
					soundplayed = TRUE
					sleep(space_delay)
		if(write_sound)
			if(!soundplayed)
				M.playsound_local(M, list('sound/effects/typewriter/1.ogg', 'sound/effects/typewriter/2.ogg'), write_sound_volume, FALSE)
		sleep(write_time)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/fade_location_blurb, src, T), duration)

/proc/fade_location_blurb(client/C, obj/T)
	animate(T, alpha = 0, time = 5, easing = EASE_IN)
	sleep(5)
	if(C)
		C.screen -= T
	qdel(T)
