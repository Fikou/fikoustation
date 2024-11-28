/client
	parent_type = /datum

/client/New()
	if(mob)
		return
	var/mob/player/new_mob = new(locate(8, 8, 1))
	new_mob.ckey = ckey

/client/Move(loc, dir)
	if(mob.move_cooldown > world.time)
		return
	mob.move_cooldown = world.time + 1
	return ..()

/client/verb/say(what as text)
	set hidden = TRUE
	world << what
