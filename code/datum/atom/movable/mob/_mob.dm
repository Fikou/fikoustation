/mob
	appearance_flags = PIXEL_SCALE|TILE_BOUND|KEEP_TOGETHER
	var/move_cooldown = 0

/mob/proc/talk(what)
	audible_message(src, "<b>[src]</b> <i>says,</i> \"[what]\"")

/mob/proc/get_move_cooldown()
	return 0.1 SECONDS

/mob/proc/get_screen_objects()
	return list()

/mob/proc/handle_click(atom/clicked_on, list/modifiers)
	. = FALSE //unhandled
	if(modifiers["shift"])
		clicked_on.examine(src)
		return TRUE

/mob/proc/walk_self(moving_dirs)
	if(move_cooldown > world.time)
		return
	var/cooldown_multiplier = 1
	var/dir_to_move = moving_dirs
	if((moving_dirs & (NORTH|SOUTH)) == (NORTH|SOUTH))
		dir_to_move &= ~(NORTH|SOUTH)
	if((moving_dirs & (EAST|WEST)) == (EAST|WEST))
		dir_to_move &= ~(EAST|WEST)
	if(dir_to_move == NONE)
		return
	if(dir_to_move in GLOB.diagonals)
		Move(get_step(src, dir_to_move & (NORTH|SOUTH)), dir_to_move & (NORTH|SOUTH))
		dir_to_move &= ~(NORTH|SOUTH)
		cooldown_multiplier = SQRT_2
	Move(get_step(src, dir_to_move), dir_to_move)
	move_cooldown = world.time + get_move_cooldown() * cooldown_multiplier

/mob/living
	var/interact_cooldown = 0
	var/max_health = 100
	var/health = 100
	var/status_flags = NONE
	var/dead = FALSE
	var/list/acceptable_bodyparts = list()
	var/list/bodyparts = list()
	var/list/holding_bodyparts = list()
	var/obj/item/bodypart/current_holder = null

/mob/living/proc/build_icon()
	return

/mob/living/Exited(atom/movable/exited, new_loc)
	if(exited in list_values(bodyparts))
		var/obj/item/bodypart/bodypart = exited
		bodypart.remove()

/mob/living/talk(what)
	if(dead)
		return
	return ..()

/mob/living/get_screen_objects()
	. = ..()
	. += new /atom/movable/screen/health()

/mob/living/walk_self(moving_dirs)
	if(dead)
		return
	return ..()

/mob/living/handle_click(atom/clicked_on, list/modifiers)
	. = ..()
	if(.)
		return
	if(dead)
		to_chat(src, "You're too busy being dead.")
		return
	if(!current_holder)
		to_chat(src, "You have no arms to do that with.")
		return
	if(interact_cooldown > world.time)
		return
	interact_cooldown = world.time + get_interact_cooldown()
	return current_holder.interact_with(clicked_on, modifiers)

/mob/living/proc/get_interact_cooldown()
	return 0.5 SECONDS

/mob/living/proc/get_held_items()
	. = list()
	for(var/obj/item/bodypart/bodypart in holding_bodyparts)
		if(!bodypart.held_item)
			continue
		. += bodypart.held_item

/mob/living/proc/drop_item(obj/item/bodypart/holding_part)
	if(!holding_part)
		holding_part = current_holder
	current_holder.held_item?.drop()

/mob/living/proc/drop_items()
	for(var/bodypart in holding_bodyparts)
		drop_item(bodypart)

/mob/living/proc/switch_held()
	if(length(holding_bodyparts) <= 1)
		return
	var/i = 1
	for(var/obj/item/bodypart/bodypart as anything in holding_bodyparts)
		if(current_holder == bodypart)
			current_holder = holding_bodyparts[i == length(holding_bodyparts) ? 1 : i + 1]
			break
		i++
	for(var/atom/movable/screen/holder_ui as anything in list_values(holding_bodyparts))
		holder_ui.update_icon()

/mob/living/proc/get_active_held_item() as /obj/item
	return current_holder?.held_item

/mob/living/proc/damage(amount)
	modify_health(-amount)
	color = list(255, 0, 0, 255, 0, 0, 255, 0, 0)
	animate(src, 0.25 SECONDS, color = "#ffffff")

/mob/living/proc/heal(amount)
	modify_health(amount)

/mob/living/proc/modify_health(amount)
	set_health(health + amount)

/mob/living/proc/set_health(new_health)
	health = clamp(new_health, 0, max_health)
	update_health()

/mob/living/proc/update_health()
	if(health == 0)
		death()
		return
	if(!client)
		return
	var/atom/movable/screen/health/health_ui = locate() in client.screen
	health_ui.update_icon()

/mob/living/proc/death()
	drop_items()
	if(dead)
		return
	transform = transform.Turn(90)
	dead = TRUE
	if(!client)
		return
	var/atom/movable/screen/health/health_ui = locate() in client.screen
	health_ui.update_icon()

/mob/living/human
	name = "human"
	icon = 'icons/mob/human.dmi'
	icon_state = "player"
	acceptable_bodyparts = list(
		BODYPART_HEAD,
		BODYPART_CHEST,
		BODYPART_ARM_RIGHT,
		BODYPART_ARM_LEFT,
		BODYPART_LEG_RIGHT,
		BODYPART_LEG_LEFT,
	)

/mob/living/human/examine(mob/user)
	var/holding_string = ""
	var/i = 1
	var/held_items = get_held_items()
	if(!length(held_items))
		holding_string = "nothing"
	for(var/obj/item/item in held_items)
		holding_string += "\a [item]"
		if(i == length(held_items) - 1)
			holding_string += ", and "
		else if(i != length(held_items))
			holding_string += ", "
		i++
	to_chat(user, "It's [src]. \He is holding [holding_string].")

/mob/living/human/Login()
	..()
	name = key

/mob/living/human/New(loc)
	..()
	gender = pick("male", "female", "neuter")
	var/rand_color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	var/list/created_bodyparts = list()
	created_bodyparts += new /obj/item/bodypart/head()
	created_bodyparts += new /obj/item/bodypart/chest()
	created_bodyparts += new /obj/item/bodypart/arm/right()
	created_bodyparts += new /obj/item/bodypart/arm/left()
	created_bodyparts += new /obj/item/bodypart/leg/right()
	created_bodyparts += new /obj/item/bodypart/leg/left()
	for(var/obj/item/bodypart/bodypart in created_bodyparts)
		bodypart.color = rand_color
		bodypart.insert(src, special = TRUE)
	build_icon()

/mob/living/human/get_move_cooldown()
	. = 0.25 SECONDS
	if(isturf(loc))
		var/turf/turf = loc
		. += turf.slowdown
	var/multiplier = 2
	if(bodyparts[BODYPART_LEG_RIGHT])
		multiplier -= 0.5
	if(bodyparts[BODYPART_LEG_LEFT])
		multiplier -= 0.5
	. *= multiplier

/mob/living/human/build_icon()
	overlays.Cut()
	overlays += build_bodyparts()

/mob/living/human/proc/build_bodyparts()
	. = list()
	for(var/bodypart_id in bodyparts)
		var/obj/item/bodypart/bodypart = bodyparts[bodypart_id]
		. += bodypart.build_icon()

/mob/living/human/get_screen_objects()
	. = ..()
	for(var/bodypart in holding_bodyparts)
		. += holding_bodyparts[bodypart]
