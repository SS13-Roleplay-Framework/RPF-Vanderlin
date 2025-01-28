/datum/round_event_control/broadcast
	name = null

/datum/round_event_control/broadcast/canSpawnEvent()
	. = ..()
	if(!.)
		return .
	if(!LAZYLEN(GLOB.speakers))
		return .
