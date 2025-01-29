/datum/round_event_control/broadcast/protectors
	name = "Reminder - Obey Protectors"
	typepath = /datum/round_event/broadcast/protectors
	weight = 30
	max_occurrences = 999
	min_players = 0
	earliest_start = 10 SECONDS

/datum/round_event/broadcast/protectors

/datum/round_event/broadcast/protectors/setup()
	return

/datum/round_event/broadcast/protectors/start()
	. = ..()
	SSloudspeak.play_broadcast(/datum/broadcast/checkpoint)
	return
