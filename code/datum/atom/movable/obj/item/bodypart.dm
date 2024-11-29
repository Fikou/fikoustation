
/obj/item/bodypart
	name = "bodypart"
	icon = 'icons/mob/human.dmi'
	var/mob/living/owner
	var/id
	var/holder_ui_type
	var/obj/item/held_item = null

/obj/item/bodypart/Exited(atom/movable/exited, new_loc)
	if(exited == held_item)
		held_item = null
		var/atom/movable/screen/active_hand_ui = owner.holding_bodyparts[src]
		active_hand_ui.update_icon()

/obj/item/bodypart/proc/insert(mob/living/mob, special = FALSE)
	owner = mob
	Move(owner)
	owner.bodyparts[id] = src
	if(holder_ui_type)
		var/atom/movable/screen/inventory_slot/held_item/holder_ui = new holder_ui_type()
		owner.holding_bodyparts[src] = holder_ui
		holder_ui.linked_bodypart = src
		if(!owner.current_holder)
			owner.current_holder = src
	if(!special)
		owner.build_icon()

/obj/item/bodypart/proc/remove(special = FALSE)
	owner.bodyparts -= id
	if(holder_ui_type)
		if(held_item)
			held_item.drop(owner)
		del(owner.holding_bodyparts[src])
		owner.holding_bodyparts -= src
		if(owner.current_holder == src)
			owner.current_holder = length(owner.holding_bodyparts) ? owner.holding_bodyparts[1] : null
			if(owner.current_holder)
				var/atom/movable/screen/holder_ui = owner.holding_bodyparts[owner.current_holder]
				holder_ui.update_icon()
	if(!special)
		owner.build_icon()
	owner = null

/obj/item/bodypart/proc/build_icon()
	var/image/built_icon = image(icon = 'icons/mob/human.dmi', icon_state = icon_state)
	built_icon.color = color
	return built_icon

/obj/item/bodypart/proc/interact_with(atom/clicked_on, list/modifiers)
	if(held_item)
		return held_item.attack(clicked_on, owner, modifiers)
	return clicked_on.interact(owner, modifiers)

/obj/item/bodypart/head
	name = "head"
	icon_state = "head"
	id = BODYPART_HEAD
	pixel_y = -8

/obj/item/bodypart/head/remove(special = FALSE)
	if(!special)
		owner.death()
	return ..()

/obj/item/bodypart/chest
	name = "chest"
	icon_state = "chest"
	id = BODYPART_CHEST

/obj/item/bodypart/chest/remove(special = FALSE)
	if(!special)
		del(owner)
		return
	return ..()

/obj/item/bodypart/arm/right
	name = "right arm"
	icon_state = "arm_right"
	id = BODYPART_ARM_RIGHT
	holder_ui_type = /atom/movable/screen/inventory_slot/held_item/right_hand
	pixel_x = 6
	pixel_y = 1

/obj/item/bodypart/arm/left
	name = "left arm"
	icon_state = "arm_left"
	id = BODYPART_ARM_LEFT
	holder_ui_type = /atom/movable/screen/inventory_slot/held_item/left_hand
	pixel_x = -6
	pixel_y = 1

/obj/item/bodypart/leg/right
	name = "right leg"
	icon_state = "leg_right"
	id = BODYPART_LEG_RIGHT
	pixel_x = 2
	pixel_y = 11

/obj/item/bodypart/leg/left
	name = "left leg"
	icon_state = "leg_left"
	id = BODYPART_LEG_LEFT
	pixel_x = -2
	pixel_y = 11
