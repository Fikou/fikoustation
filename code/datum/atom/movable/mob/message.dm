/proc/audible_message(atom/source, text, range = 7)
	for(var/mob/hearing_mob as anything in hearers(range, source))
		to_chat(hearing_mob, text)

/proc/visible_message(atom/source, text, range = 7)
	for(var/mob/seeing_mob as anything in viewers(range, source))
		to_chat(seeing_mob, text)

/proc/to_chat(who, text)
	who << text
