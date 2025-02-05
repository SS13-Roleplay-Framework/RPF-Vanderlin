#define LISTENING_PHRASE 0
#define LISTENING_YESNO 1
#define LISTENING_NOT 2

GLOBAL_LIST_EMPTY(interview_answers)


/obj/structure/camera
	name = "Camera"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	flags_1 = HEAR_1
	var/active = FALSE
	var/listen_type = LISTENING_NOT
	var/current_question_index = 0
	var/list/questions = list( // String, Audio path, Listentype, and whether to autoplay, and if so, in how long.
		list("You will not be able to repeat this interview. You will not be able to correct your answers. Do you understand what has been spoken, YES or NO.", 'sound/vo/camera/id_2.ogg', LISTENING_YESNO, 13.426 SECONDS),
		list("What is your FIRST NAME.", 'sound/vo/camera/id_3.ogg', LISTENING_PHRASE, 2.494 SECONDS),
		list("What is your LAST NAME, OF BIRTH.", 'sound/vo/camera/id_4.ogg', LISTENING_PHRASE, 3.717 SECONDS),
		list("Were you born within the bounds of the 'INNER EMPIRE' that is to say, Not within any of the colonies, YES or NO.", 'sound/vo/camera/id_5.ogg', LISTENING_YESNO, 11.869 SECONDS),
		list("Do you pledge to remain subservient to the local law enforcement of this settlement? YES or NO.", 'sound/vo/camera/id_6.ogg', LISTENING_YESNO, 8.871 SECONDS),
		list("Do you believe that the position of Queen Mary the First and King Lexanor The Fourth as Monarchs is backed by the Mandate of God? YES or NO.", 'sound/vo/camera/id_7.ogg', LISTENING_YESNO, 13.569 SECONDS),
	)
	var/list/answer_storage = list() // CKEY is saved first!!
	var/list/already_interviewed = list() // No redo's.
	var/mob/interacted = null

/obj/structure/camera/proc/beginQuestioning()
	if(!current_question_index == 0 || active)
		return FALSE // already begun
	active = TRUE
	already_interviewed += interacted
	say("Hello, And welcome to the automated welcoming assignment system of the Aurum Mare Trade Company's travel division.")
	playsound(src.loc, 'sound/vo/camera/begin_id.ogg', 85, FALSE)
	sleep(9.803 SECONDS)
	say("You will now answer 5 questions about your person, to be applied to your Local Identification.")
	playsound(src.loc, 'sound/vo/camera/id_1.ogg', 85, FALSE)
	sleep(9.668 SECONDS)
	nextQuestion()
	playQuestion()

/obj/structure/camera/proc/debug_print()
	to_chat(world, english_list(GLOB.interview_answers))

/obj/structure/camera/proc/endQuestioning()
	say("Have a safe stay at this settlement, God save the King, all Hail the Queen.")
	playsound(src.loc, 'sound/vo/camera/id_8.ogg', 85, FALSE)
	current_question_index = 0
	listen_type = LISTENING_NOT
	interacted = null
	active = FALSE
	GLOB.interview_answers += list(answer_storage)
	answer_storage.Cut()

/obj/structure/camera/proc/playQuestion()
	var/list/fuck = questions[current_question_index]
	say(fuck[1])
	playsound(src.loc, fuck[2], 85, FALSE)
	listen_type = LISTENING_NOT
	spawn(fuck[4])
		listen_type = fuck[3]

/obj/structure/camera/proc/nextQuestion()
	current_question_index++

/obj/structure/camera/attack_hand(user)
	if(active)
		return
	if(locate(user) in already_interviewed)
		say("Apologies, but you may not partake in the interview a second time.")
		return
	interacted = user
	beginQuestioning()

/obj/structure/camera/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	. = ..()
	if(speaker == src || !speaker == interacted)
		return
	if(!ishuman(speaker) || !ismob(speaker))
		return
	if(listen_type == LISTENING_NOT)
		return FALSE // Deafened.
	var/message2recognize = sanitize_hear_message(raw_message)
	message2recognize = trim(message2recognize, 16)
	submitAnswer(message2recognize, speaker)

/obj/structure/camera/proc/Begin()

/obj/structure/camera/proc/processAnswer(string, var/mob/speaker)
	if(!LAZYLEN(answer_storage))
		answer_storage += speaker.ckey
	var/logthis = TRUE
	if(current_question_index == 1) // just so it doesn't get logged on the confirmation.
		logthis = FALSE
	nextQuestion()
	if(logthis)
		answer_storage += string
		to_chat(world, "Logging")
	if(current_question_index >= LAZYLEN(questions)+1)
		endQuestioning()
		return
	else
		playQuestion()
		return

/obj/structure/camera/proc/submitAnswer(string, var/mob/speaker)
	if(listen_type == LISTENING_YESNO)
		var/list/allowed = list("Yes","Yes,", "Yes.", "Always.", "Forever.", "No.", "Never.")
		if(!findtext(string, allowed))
			say("Invalid answer. Please answer with either 'Yes' or 'No'.")
			return
		else
			if(findtext(string, list("Yes","Yes,", "Yes.", "Always.", "Forever.")))
				processAnswer("Yes.", speaker)
			else
				processAnswer("No.", speaker)
	else
		processAnswer(string, speaker)

#undef LISTENING_PHRASE
#undef LISTENING_YESNO
#undef LISTENING_NOT
