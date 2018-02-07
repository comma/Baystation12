/datum/map_template/ruin/exoplanet/observatory
	name = "Observatory"
	id = "planetsite_observatory"
	description = "Alien ruin with a device that lets you peek around overmap."
	suffixes = list("observatory/observatory.dmm")
	cost = 1

//Alien bullshit power generator. Requires specific gases to be present to run, will explode spectaculary if pushed to higher power settings.
/obj/machinery/power/aliengen
	name = "alien machine"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano50"
	desc = "A block of unknown material, it resists your effort to pry it apart. It has several tiny intakes on the surface, and an oddly shaped plug on the back."
	var/list/needed_gases
	var/powerlevel = 2
	var/active = 0
	var/global/list/buttons = list("square","round","triangular")

/obj/machinery/power/aliengen/Initialize()
	. = ..()
	buttons = shuffle(buttons)
	if(!active)
		STOP_PROCESSING(SSmachines, src)
	if(!needed_gases)
		needed_gases = list()
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/GM = T.return_air()
		for(var/gas in GM.gas)
			if(GM.gas[gas] > 0.1)
				needed_gases += gas

/obj/machinery/power/aliengen/update_icon()
	icon_state = "ano5[active]"

/obj/machinery/power/aliengen/Process()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/GM = T.return_air()
	for(var/gas in needed_gases)
		if(!(gas in GM.gas))
			toggle()
			return
	GM.remove_volume(5)

	add_avail(250000*powerlevel*powerlevel) //yes 250 kW per powersetting squared. I did say 'bullshit' alien powergen
	if(powerlevel > 2 && prob(100)) //however running it at max setting has some risks
		implode()

/obj/machinery/power/aliengen/proc/toggle()
	active = !active
	if(active)
		START_PROCESSING(SSmachines, src)
		visible_message("[src] [pick("beeps","blorps","buzzes","pings")] and starts humming.")
	else
		STOP_PROCESSING(SSmachines, src)
		visible_message("[src] [pick("beeps","blorps","buzzes","pings")] and goes quiet.")
	update_icon()

/obj/machinery/power/aliengen/proc/implode()
	playsound(loc, 'sound/effects/phasein.ogg', 50, 1, 5)
	visible_message("<span class='warning'>[src] flashes very bright for a moment before disappearing!</span>")
	for(var/atom/A in circlerange(src,6))
		A.ex_act(1)
	qdel(src)

/obj/machinery/power/aliengen/attack_hand(mob/user)
	interact(user)

/obj/machinery/power/aliengen/interact(mob/user)
	var/dat = list()
	dat+= "<a href='?src=\ref[src];toggle=1'>[buttons[1]] button</a>"
	dat+= "<a href='?src=\ref[src];powerlevel=1'>[buttons[2]] button</a>"
	dat+= "<a href='?src=\ref[src];powerlevel=-1'>[buttons[3]] button</a>"
	dat+= "<font face='Shage'>[powerlevel]</font>"
	show_browser(user, jointext(dat,"<br>"), "window=aliengen")

/obj/machinery/power/aliengen/OnTopic(var/user, var/list/href_list)
	if(href_list["toggle"])
		toggle()
		return TOPIC_REFRESH
	if(href_list["powerlevel"])
		var/shift = text2num(href_list["powerlevel"])
		var/oldlevel = powerlevel
		powerlevel = Clamp(1,powerlevel+shift,3)
		if(active && powerlevel != oldlevel)
			visible_message("[src] starts humming [shift > 0 ? "louder" : "softer"].")
		return TOPIC_REFRESH

/obj/machinery/power/aliengen/attackby(obj/item/W, mob/user)
	if(isCrowbar(W))
		anchored = !anchored
		if(!anchored)
			visible_message("[user] pries [src] out of its slot, disconnecting the plug.")
			disconnect_from_network()
		else
			visible_message("[user] secures [src] to the floor, connecting the plug.")
			connect_to_network()
	else
		..()

//Magical machine that connects powernets in certain range

/obj/machinery/power/relay
	name = "alien machine"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano60"
	desc = "A block of unknown material, it resists your effort to pry it apart. It has an oddly shaped plug on the back and a layered mesh on the top."
	var/max_dist = 21

/obj/machinery/power/relay/connect_to_network()
	. = ..()
	if(.)
		for(var/obj/machinery/power/relay/rly in SSmachines.machinery)
			if(rly != src && rly.z == z && rly.powernet && get_dist(src,rly) <= max_dist)
				merge_powernets(powernet, rly.powernet)

/obj/machinery/power/relay/Process()
	..()
	update_icon()

/obj/machinery/power/relay/update_icon()
	if(avail())
		icon_state = "ano61"
	else
		icon_state = "ano60"

//Machine that lets you peek on overmap.

/obj/machinery/observatory
	name = "alien machine"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano90"

/obj/machinery/observatory/update_icon()
	if(stat & NOPOWER)
		icon_state = "ano90"
	else
		icon_state = "ano91"

/obj/item/weapon/cell/alium
	name = "alien device"
	desc = "It hums with power."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "instrument"
	maxcharge = 5000
	origin_tech = list(TECH_POWER = 7)

/obj/item/weapon/cell/alium/update_icon()
	return

/obj/item/weapon/cell/alium/Initialize()
	. = ..()
	charge = 0

/obj/machinery/power/apc/alium
	name = "alien device"
	desc = "It's affixed to the floor, with a thick wire going into it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano10"
	cell_type = /obj/item/weapon/cell/alium
	
/obj/machinery/power/apc/hyper/alium/update_icon()
	icon_state = "ano11"
	icon_state = "ano10"