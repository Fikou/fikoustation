/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	var/damage = 0
	var/dismember_chance = 0

/obj/item/proc/attack(atom/target, mob/user, list/modifiers)
	if(!istype(target, /mob/living))
		return
	var/mob/living/living_target = target
	living_target.damage(damage)
	if(prob(dismember_chance) && length(living_target.bodyparts))
		var/list/viable_bodyparts = living_target.bodyparts.Copy()
		if(length(viable_bodyparts) != 1)
			if(living_target.health > 25)
				viable_bodyparts -= BODYPART_HEAD
			viable_bodyparts -= BODYPART_CHEST
		var/obj/item/bodypart/lost_bodypart = living_target.bodyparts[pick(viable_bodyparts)]
		lost_bodypart.Move(lost_bodypart.drop_location())
	visible_message(user, "[user] attacks [target] with \a [src]!", range = 5)

/obj/item/proc/pickup(mob/living/user)
	Move(user.current_holder)
	user.current_holder.held_item = src
	var/atom/movable/screen/active_hand_ui = user.holding_bodyparts[user.current_holder]
	active_hand_ui.update_icon()

/obj/item/proc/drop(mob/living/user)
	Move(drop_location())

/obj/item/interact(mob/living/user, list/modifiers)
	pickup(user)
	return TRUE
