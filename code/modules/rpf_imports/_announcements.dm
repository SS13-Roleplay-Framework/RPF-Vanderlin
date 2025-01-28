GLOBAL_LIST_EMPTY(speakers)
GLOBAL_LIST_EMPTY(televisions)
GLOBAL_LIST_EMPTY(radios)

#define PUNCTUATION list("!", ".", "\"", ")", "'", ",", "?", ":", ";")

#define AUDIOSOURCES GLOB.speakers
#define TVSOURCES GLOB.televisions
#define RADIOSOURCES GLOB.radios

#define PLAY_LOCAL 1
#define PLAY_AREA 0
#define PLAY_GLOBAL -1

#define ALL_SPEAKERS 0

#define SILENT null

proc/chaticon(icon_state, target=world, icon='icons/misc_chat.dmi', thissize, classes, w, h)
    return icon2html(icon, target, icon_state, realsize = thissize, other_classes = classes, w=w, h=h)

SUBSYSTEM_DEF(loudspeak)
	name = "Announcement"
	wait = 10
	flags = SS_NO_FIRE
	priority = INIT_ORDER_LOUDSPEAK
	runlevels = RUNLEVEL_GAME
	can_fire = 0

/datum/controller/subsystem/loudspeak/Initialize()
	..()

/datum/controller/subsystem/loudspeak/proc/remove_deaf(mobs)
	for(var/mob/m in mobs)
		if(!m.can_hear())
			mobs -= m
	return mobs

/datum/controller/subsystem/loudspeak/proc/get_mobs_around_obj(range, obj)
	var/list/mobs = list()
	if (range == PLAY_GLOBAL)
		var/list/globalmobs = GLOB.mob_list
		return globalmobs
	else if(range == PLAY_AREA)
		var/area/a = get_area(obj)
		if(a)
			for(var/mob/m in a)
				mobs |= m
			return mobs
		else
			message_admins("FATAL ERROR: NO AREA AT LOUDSPEAKER")
			return null
	else if(range >= PLAY_LOCAL)
		for(var/mob/m in view(range, obj))
			mobs |= m
		return mobs

/datum/controller/subsystem/loudspeak/proc/get_clients_from_list(mobs)
	var/list/clients = list()
	for(var/mob/M in mobs)
		if(M.client)
			clients |= M
		else
			continue
	return clients


/datum/controller/subsystem/loudspeak/proc/match_speakers(id)
	if(id == PLAY_GLOBAL)
		return AUDIOSOURCES
	var/list/sources = list()
	for(var/obj/structure/announcementspeaker/source in AUDIOSOURCES)
		if(id == source.id)
			sources |= source
		else
			continue
	return sources

/datum/controller/subsystem/loudspeak/proc/playsound_from_speakers(var/id, var/sound, var/volume, var/variance, var/range = 5)
	for(var/obj/s in match_speakers(id))
		playsound(s.loc, sound, volume, variance, extrarange = range, falloff = 1)

/datum/controller/subsystem/loudspeak/proc/handle_playsound(var/datum/broadcast_template/speakdata, var/list/mobs, var/id, var/sound = null, var/volume = 100, var/vary = 0)
	if(sound)
		if(speakdata.broadcast_range <= PLAY_GLOBAL)
			for(var/mob/M in GLOB.mob_list)
				M.playsound_local(M, sound, volume, FALSE)
		else if(speakdata.broadcast_range == PLAY_AREA)
			for(var/mob/M in mobs)
				M.playsound_local(M, sound, volume, FALSE)
		else if(speakdata.broadcast_range >= PLAY_LOCAL)
			playsound_from_speakers(id, sound, volume, vary, speakdata.broadcast_range)

/datum/controller/subsystem/loudspeak/proc/prep_announce(var/datum/broadcast_template/speakdata, id, message, var/datum/language/speaking=null, raw, mute = FALSE)

	var/list/speakers = match_speakers(id)

	var/list/mobs = list()
	for(var/obj/s in speakers)
		mobs |= get_mobs_around_obj(speakdata.broadcast_range, s)

	if(LAZYLEN(speakdata.additional_talk_sound) && !mute)
		SSloudspeak.handle_playsound(speakdata, mobs, id, safepick(speakdata.additional_talk_sound), speakdata.additional_talk_sound_volume, speakdata.additional_talk_sound_vary)

	if(isnull(message))
		return
	if(isnull(raw))
		raw = message

	announce(speakdata, speakers, message, mobs, speaking, raw)

/datum/controller/subsystem/loudspeak/proc/announce(var/datum/broadcast_template/speakdata, speakers, message, mobs, var/datum/language/speaking=null, raw)
	var/width = speakdata.width
	var/height = speakdata.height
/*
	for(var/obj/s in speakers)
		to_world(get_clients_from_list(mobs_in_view(world.view, s)))
		INVOKE_ASYNC(s, /atom/movable/proc/animate_chat, "<span class='[speakdata.speakerstyle]'>[message]</span>", null, 0, get_clients_from_list(mobs_in_view(world.view, s)), 5 SECONDS, 1)
*/
	if(raw)
		for(var/obj/speaker in speakers)
			for(var/mob/M in view(world.view, speaker))
				if(locate(M) in mobs)
					M.create_chat_message(speaker, speaking, raw, spans = list("emote"))
	for(var/mob/M in mobs)
		to_chat(M,"[chaticon(speakdata.icon, M, classes="nosizemargin",  w=width, h=height)] <span class='[speakdata.speakerstyle]'><span class='[speakdata.textstyle]'>[message]</span></span>")

/datum/broadcast_template
	var/name = "TEST TEMPLATE" // for admin tool bs

	var/icon = "loudspeaker"
	var/width = null
	var/height = null

	var/broadcast_start_sound = list('sound/effects/broadcasttest.ogg')
	var/broadcast_start_sound_volume = 85

	var/broadcast_end_sound = list('sound/effects/broadcasttestend.ogg') //"feedbacknoise"
	var/broadcast_end_sound_volume = 50

	var/list/additional_talk_sound = list('sound/effects/red_loudspeaker_01.ogg','sound/effects/red_loudspeaker_02.ogg','sound/effects/red_loudspeaker_03.ogg','sound/effects/red_loudspeaker_04.ogg','sound/effects/red_loudspeaker_05.ogg','sound/effects/red_loudspeaker_06.ogg')//list('sound/effects/megaphone_03.ogg','sound/effects/megaphone_04.ogg')
	var/additional_talk_sound_vary = 0
	var/additional_talk_sound_volume = 75

	var/speakerstyle = "ldspkr" // h3 + warning makes it CURLY (disco freaky) :>
	var/textstyle = "ldspkrmsg"

	var/broadcast_range = PLAY_AREA

/*
	additional_talk_sound = list('sound/effects/loudspeaker_01.ogg','sound/effects/loudspeaker_02.ogg','sound/effects/loudspeaker_03.ogg','sound/effects/loudspeaker_04.ogg','sound/effects/loudspeaker_05.ogg')
	additional_talk_sound_volume = 55
	// BLUE ^^
*/

/datum/broadcast_template/announcement
	broadcast_start_sound = null//'sound/effects/announce.ogg'

/datum/broadcast_template/base

	name = "Standard"
	width = 26
	height = 26

/datum/broadcast_template/automated

	name = "Automated"
	width = 26
	height = 26
	additional_talk_sound = list()

/datum/broadcast_template/automated/everyone
	broadcast_range = PLAY_GLOBAL

/datum/broadcast
	var/list/dialogue = list()
	var/id = ALL_SPEAKERS
	var/datum/broadcast_template/template = /datum/broadcast_template/automated

/datum/broadcast/New()
	template = new template

/datum/broadcast/king
	dialogue = list(
		list('sound/effects/announce_edited.ogg', null, null, " The loudspeakers suddenly come to life..", 2 SECONDS),
		list('sound/vo/broadcast/propa1.ogg', "PA system", "coldly states,", "Today marks the day of the king's birth. Let us all take a moment to honor him. May our loyalty remain steadfast, and may his life endure for generations to come. Long live Lexanor.", 14 SECONDS),
		list('sound/vo/broadcast/city_anthemlong_intro_01_edited.ogg', null, null, " The loudspeakers suddenly play the anthem...", 5 SECONDS)
	)


/datum/broadcast/civil
	dialogue = list(
		list('sound/effects/announce_edited.ogg', null, null, " The loudspeakers suddenly come to life..", 2 SECONDS),
		list('sound/vo/broadcast/propa2.ogg', "PA system", "coldly states,", "Attention, citizens. Compliance with the crown's protectors ensures safety. Unauthorized gatherings are strictly prohibited.", 10 SECONDS),
		list(null, null, null, " The loudspeakers come to a sudden silence...", 5 SECONDS)
	)

/datum/broadcast/curfew // sound, name, verb, text, delay // CAN HAVE NAME AND VERB AS NULL
	template = /datum/broadcast_template/automated/everyone
	dialogue = list(
		list('sound/effects/owannouncer_boop.ogg', null, null, " The loudspeakers blare to life...", 3 SECONDS),
		list('sound/vo/broadcast/curfewsoft_01.ogg', "UNKNOWN", "coldly speaks,", "Please clear the streets, the curfew is now active. No foot traffic is allowed until curfew is lifted.", 10 SECONDS),
		list('sound/vo/broadcast/curfewsoft_02.ogg', "UNKNOWN", "coldly speaks,", " All unneccessary visitation has been cancelled until further notice, unless you are otherwise authorized.", 11 SECONDS),
		list('sound/vo/broadcast/curfewsoft_03.ogg', "UNKNOWN", "coldly speaks,", "Violators will be subject to interrogation, and detained when neccessary. Remember, the boldest measures are the safest.", 12 SECONDS),
		list('sound/effects/owannouncer_boop_end.ogg', null, null, " The loudspeakers come to a sudden silence...", 5 SECONDS)
	)

/datum/controller/subsystem/loudspeak/proc/play_broadcast(var/type)
	var/datum/broadcast/B = new type
	B.play()

/datum/broadcast/proc/play()
	for (var/i = 1; i <= length(dialogue); i++)
		var/list/mobs = list()
		for(var/obj/s in AUDIOSOURCES)
			mobs |= SSloudspeak.get_mobs_around_obj(template.broadcast_range, s)
		SSloudspeak.handle_playsound(template, mobs, id, get_sound(i), 85, 0)
		var/text = "[get_name(i)] [get_verb(i)], \"[get_text(i)]\""
		if(!get_name(i) || !get_verb(i))
			SSloudspeak.prep_announce(template, id, get_text(i), null, get_text(i), null, get_text(i), TRUE)
		else
			SSloudspeak.prep_announce(template, id, text, null, get_text(i), FALSE)
		sleep(get_delay(i))
	special()
	end()

/datum/broadcast/proc/special()
	return

/datum/broadcast/proc/end()
	qdel(src) // STUPID SO STUPID FUCK!!

/datum/broadcast/proc/get_sound(var/index)
	return dialogue[index][1]

/datum/broadcast/proc/get_name(var/index)
	return dialogue[index][2]

/datum/broadcast/proc/get_verb(var/index)
	return dialogue[index][3]

/datum/broadcast/proc/get_text(var/index)
	return dialogue[index][4]

/datum/broadcast/proc/get_delay(var/index)
	return dialogue[index][5]
