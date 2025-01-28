
/**
 * proc for playing a screen_text on a mob.
 * enqueues it if a screen text is running and plays i otherwise
 * Arguments:
 * * text: text we want to be displayed
 * * alert_type: typepath for screen text type we want to play here
 */
// /mob/proc/play_screen_text(text, alert = /atom/movable/screen/text/screen_text)


/atom/movable/screen/text/screen_text/typewriter
	style_open = "<span style=\"text-align: left; vertical-align:'top'; font-family: 'Javanese Text'; -dm-text-outline: 1 black; font-size: 12px;\">"
	screen_loc = "LEFT+6,BOTTOM+0.75";
	maptext_height = 64
	maptext_width = 512
	fade_out_delay = 2 SECONDS
	play_delay = 1.5

	var/write_sound_volume=25
	var/write_sound = list('sound/effects/typewriter/1.ogg', 'sound/effects/typewriter/2.ogg')

	var/space_delay = 0
	var/space_sound_volume=10
	var/space_sound = list('sound/effects/typewriter/space1.ogg', 'sound/effects/typewriter/space2.ogg')

	var/new_line_delay = 5
	var/new_line_sound_volume=85
	var/new_line_sound = list('sound/effects/typewriter/end1.ogg', 'sound/effects/typewriter/end2.ogg')

	var/ignore_new_lines = FALSE
	var/ignore_spaces = FALSE

/atom/movable/screen/text/screen_text/typewriter/play_to_client()

	var/client/owner = owner_ref
	if(!owner)
		return

	owner.screen += src

	if(fade_in_time)
		animate(src, alpha = 255)

	var/list/lines_to_skip = list()
	var/static/html_locate_regex = regex("<.*>")
	var/tag_position = findtext(text_to_play, html_locate_regex)
	var/reading_tag = TRUE

	while(tag_position)
		if(reading_tag)
			if(text_to_play[tag_position] == ">")
				reading_tag = FALSE
				lines_to_skip += tag_position
			else
				lines_to_skip += tag_position
			tag_position++
		else
			tag_position = findtext(text_to_play, html_locate_regex, tag_position)
			reading_tag = TRUE

	// tag_position = findtext(text_to_play, "&nbsp;")
	// while(tag_position)
	// 	lines_to_skip.Add(tag_position, tag_position+1, tag_position+2, tag_position+3, tag_position+4, tag_position+5)
	// 	tag_position = tag_position + 6
	// 	tag_position = findtext(text_to_play, "&nbsp;", tag_position)

	var/mob/M = owner.mob

	for(var/letter = 2 to length(text_to_play) + letters_per_update step letters_per_update)
		if(letter in lines_to_skip)
			continue

		maptext = "[style_open][copytext_char(text_to_play, 1, letter)][style_close]"
		var/soundplayed = FALSE
		var/char = copytext_char(text_to_play, letter-1, letter)
		if(char == "\n") // for some reason using "char == "" or "\n" won't work.."
			if(ignore_new_lines)
				soundplayed = TRUE
			if(new_line_sound)
				if(!soundplayed)
					M.playsound_local(M, new_line_sound, new_line_sound_volume, FALSE)
					soundplayed = TRUE
					sleep(new_line_delay)
		else if(char == " ")
			if(ignore_spaces)
				soundplayed = TRUE
			if(space_sound)
				if(!soundplayed)
					M.playsound_local(M, space_sound, space_sound_volume, FALSE)
					soundplayed = TRUE
					sleep(space_delay)
		if(write_sound)
			if(!soundplayed)
				M.playsound_local(M, write_sound, write_sound_volume, FALSE)
		if(QDELETED(src))
			return
		sleep(play_delay)

	if(auto_end)
		addtimer(CALLBACK(src, .proc/fade_out), fade_out_delay)
