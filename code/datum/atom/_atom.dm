/atom
	appearance_flags = PIXEL_SCALE

/atom/proc/examine(mob/user)
	to_chat(user, "It's \a [src]. [desc]")

/atom/proc/interact(mob/living/user, obj/item/bodypart/used, list/modifiers)
	return FALSE

/atom/proc/drop_location()
	return null
