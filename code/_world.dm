/world
	fps = 60
	icon_size = 32
	view = 7
	movement_mode = TILE_MOVEMENT_MODE

/world/New()
	..()
	TgsNew()
	TgsInitializationComplete()

/world/Reboot()
	TgsReboot()
	..()

/world/Topic()
	TGS_TOPIC
	..()

/world/Tick()
	for(var/client/client as anything in GLOB.clients)
		client.handle_movement()

var/global/datum/global_vars/GLOB = new /datum/global_vars()

/datum/global_vars

/proc/print(...)
	var/printed_string = ""
	var/i = 1
	for(var/arg in args)
		printed_string += "[arg][i == length(args) ? "" : " "]"
	world << printed_string
	world.log << printed_string
