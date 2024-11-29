GLOBAL_LIST_EMPTY(clients)

/client
	parent_type = /datum
	var/list/movement_keys = list(
		"W" = NORTH,
		"A" = WEST,
		"S" = SOUTH,
		"D" = EAST,
	)
	var/list/key_mapping_mob = list(
		"T" = "say",
	)
	var/list/key_mapping_living = list(
		"Q" = "drop",
		"X" = "switch_held",
	)
	var/list/key_mapping_human = list(
	)
	var/moving_dirs = NONE
	var/free_move = 0

/client/New()
	GLOB.clients += src
	var/const/login = {"
	<html>
	<head><title>Welcome!</title></head>
	<body>
	You are playing Space Station 13! This is licensed under CC BY-NC-SA 4.0. It uses TGS DMAPI, licensed under MIT.
	</body>
	</html>
	"}
	src << browse(login, "window=login")
	if(!mob)
		var/mob/living/human/new_mob = new(locate(8, 8, 1))
		new_mob.ckey = ckey
	build_ui()

/client/Del()
	GLOB.clients -= src

/client/Move(loc, dir)
	return

/client/Click(object, location, control, params)
	mob.handle_click(object, params2list(params))
	..()

/client/proc/build_ui()
	screen.Cut()
	var/list/screen_objects = list()
	screen_objects += new /atom/movable/screen/background_left()
	screen_objects += new /atom/movable/screen/background_right()
	screen_objects += mob.get_screen_objects()
	for(var/atom/movable/screen/screen_object as anything in screen_objects)
		screen_object.owner = mob
		screen += screen_object
		screen_object.update_icon()

/client/proc/handle_movement()
	mob.walk_self(moving_dirs)

/client/proc/set_move_dir(dir, state)
	if(!(dir in GLOB.cardinals))
		return
	if(state)
		if(moving_dirs && !(moving_dirs & dir) && world.time > free_move)
			if((dir & (NORTH|SOUTH) && !(moving_dirs & (NORTH|SOUTH))) || (dir & (EAST|WEST) && !(moving_dirs & (EAST|WEST))))
				mob.move_cooldown = world.time
				mob.walk_self(dir)
		moving_dirs |= dir
	else
		if(free_move <= world.time)
			free_move = world.time + mob.get_move_cooldown() * SQRT_2
		moving_dirs &= ~dir

/client/verb/KeyDown(key as text)
	set hidden = TRUE
	if(movement_keys[key])
		set_move_dir(movement_keys[key], TRUE)
		return
	var/action = key_mapping_mob[key]
	if(action)
		switch(action)
			if("say")
				winset(src, "input", "focus=true")
		return
	if(!istype(mob, /mob/living))
		return
	var/mob/living/living_mob = mob
	action = key_mapping_living[key]
	if(action)
		switch(action)
			if("drop")
				if(living_mob.dead)
					return
				living_mob.drop_item()
			if("switch_held")
				if(living_mob.dead)
					return
				living_mob.switch_held()
		return
	if(!istype(mob, /mob/living/human))
		return
	var/mob/living/human/human_mob = mob
	action = key_mapping_human[key]
	if(action)
		switch(action)
			if("placeholder")
				return
		return

/client/verb/KeyUp(key as text)
	set hidden = TRUE
	if(movement_keys[key])
		set_move_dir(movement_keys[key], FALSE)
		return
	var/action = key_mapping_mob[key]
	if(action)
		switch(action)
			if("placeholder")
				return
		return
	if(!istype(mob, /mob/living))
		return
	var/mob/living/living_mob = mob
	action = key_mapping_living[key]
	if(action)
		switch(action)
			if("placeholder")
				return
		return
	if(!istype(mob, /mob/living/human))
		return
	var/mob/living/human/human_mob = mob
	action = key_mapping_human[key]
	if(action)
		switch(action)
			if("placeholder")
				return
		return

/client/verb/say(what as text)
	set hidden = TRUE
	mob.talk(what)
	winset(src, "map", "focus=true")

/client/verb/setZoomSize()
	set name = "Set Zoom Size"
	set category = "OOC"
	var/zoom = input(src, "Set zoom amount. Set to 0 to stretch the window to fit.", "Zoom Size", 0) as num
	if(zoom == null || zoom < 0)
		return
	if(zoom > 16)
		zoom = 16
	winset(src, "map", "zoom=[zoom]")

/client/verb/setZoomMode()
	set name = "Set Zoom Mode"
	set category = "OOC"
	var/static/list/zoom_modes = list(
		"Nearest Neighbour" = "distort",
		"Normal" = "normal",
		"Bilinear Sampling" = "blur",
	)
	var/mode = input(src, "Set zoom mode.", "Zoom Mode", "Nearest Neighbour") in zoom_modes
	if(!mode)
		return
	winset(src, "map", "zoom-mode=[zoom_modes[mode]]")

/client/verb/respawn()
	set name = "Respawn"
	set category = "OOC"
	if(istype(mob, /mob/living))
		var/mob/living/living_mob = mob
		if(!living_mob.dead)
			to_chat(src, "You are not dead yet!")
			return
	var/mob/living/human/new_mob = new(locate(8, 8, 1))
	new_mob.ckey = ckey
	build_ui()

