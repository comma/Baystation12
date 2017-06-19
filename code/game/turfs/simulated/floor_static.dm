// This type of flooring cannot be altered short of being destroyed and rebuilt.
// Use this to bypass the flooring system entirely ie. event areas, holodeck, etc.

/turf/simulated/floor/fixed
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = null

/turf/simulated/floor/fixed/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/stack) && !istype(C, /obj/item/stack/cable_coil))
		return
	return ..()

/turf/simulated/floor/fixed/update_icon()
	return

/turf/simulated/floor/fixed/is_plating()
	return 0

/turf/simulated/floor/fixed/set_flooring()
	return

/turf/simulated/floor/fixed/alium
	name = "alien plating"
	desc = "This obviously wasn't made for your feet."
	icon = 'icons/turf/flooring/alium.dmi'
	icon_state = "jaggy"
	var/global/acolor

/turf/simulated/floor/fixed/alium/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/weapon/crowbar))
		to_chat(user, "<span class='notice'>There isn't any openings big enough to pry it away...</span>")
		return
	return ..()
	
/turf/simulated/floor/fixed/alium/New()
	..()
	if(!acolor)
		acolor = rgb(rand(40,200),rand(40,200),rand(40,200))
	color = acolor
	icon_state = "[icon_state][((x + y) ^ ~(x * y)) % 7]"

/turf/simulated/floor/fixed/alium/curves
	icon_state = "curvy"