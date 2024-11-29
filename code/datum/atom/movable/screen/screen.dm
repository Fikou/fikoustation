/atom/movable/screen
	name = "ui"
	icon = 'icons/ui/ui.dmi'
	var/mob/owner

/atom/movable/screen/proc/update_icon()
	return

/atom/movable/screen/inventory_slot
	name = "inventory slot"
	icon_state = "inventory"

/atom/movable/screen/inventory_slot/held_item
	var/obj/item/bodypart/linked_bodypart = null

/atom/movable/screen/inventory_slot/held_item/update_icon()
	var/mob/living/living_owner = owner
	if(!istype(living_owner))
		return
	overlays.Cut()
	if(living_owner.current_holder == linked_bodypart)
		overlays += image('icons/ui/ui.dmi', "current_part")
	vis_contents = list(linked_bodypart.held_item)

/atom/movable/screen/inventory_slot/held_item/right_hand
	icon_state = "right_hand"
	screen_loc = "ui:1,7"

/atom/movable/screen/inventory_slot/held_item/left_hand
	icon_state = "left_hand"
	screen_loc = "ui:3,7"

/atom/movable/screen/background_left
	icon = 'icons/ui/background.dmi'
	screen_loc = "ui:1,1"

/atom/movable/screen/background_right
	icon = 'icons/ui/background2.dmi'
	screen_loc = "ui2:1,1"

/atom/movable/screen/health
	name = "health"
	icon_state = "health_good"
	screen_loc = "ui2:1,8"

/atom/movable/screen/health/update_icon()
	var/mob/living/living_owner = owner
	if(!istype(living_owner))
		return
	if(living_owner.dead)
		icon_state = "health_dead"
	else if(living_owner.health > 50)
		icon_state = "health_good"
	else if(living_owner.health > 0)
		icon_state = "health_bad"
