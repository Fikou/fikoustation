/proc/list_values(list)
	. = list()
	for(var/key in list)
		. += list[key]
