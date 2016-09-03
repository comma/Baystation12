/* Holograms!
 * Contains:
 *		Holopad
 *		Hologram
 *		Other stuff
 */

/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/


/*
 * Holopad
 */

#define HOLOPAD_PASSIVE_POWER_USAGE 1
#define HOLOGRAM_POWER_USAGE 2
#define RANGE_BASED 4
#define AREA_BASED 6

var/const/HOLOPAD_MODE = RANGE_BASED

/obj/machinery/hologram/holopad
	name = "\improper AI holopad"
	desc = "It's a floor-mounted device for projecting holographic images. It is activated remotely."
	icon_state = "holopad0"

	layer = TURF_LAYER+0.1 //Preventing mice and drones from sneaking under them.

	var/power_per_hologram = 500 //per usage per hologram
	idle_power_usage = 5
	use_power = 1

	var/list/mob/living/silicon/ai/masters = new() //List of AIs that use the holopad
	var/last_request = 0 //to prevent request spam. ~Carn
	var/holo_range = 5 // Change to change how far the AI can move away from the holopad before deactivating.

/obj/machinery/hologram/holopad/attack_hand(var/mob/living/carbon/human/user) //Carn: Hologram requests.
	if(!istype(user))
		return
	world << "USER WANTS OUT."
	if(alert(user,"Would you like to request an AI's presence?",,"Yes","No") == "Yes")
		if(last_request + 200 < world.time) //don't spam the AI with requests you jerk!
			last_request = world.time
			user << "<span class='notice'>You request an AI's presence.</span>"
			var/area/area = get_area(src)
			for(var/mob/living/silicon/ai/AI in living_mob_list_)
				if(!AI.client)	continue
				AI << "<span class='info'>Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>.</span>"
		else
			user << "<span class='notice'>A request for AI presence was already sent recently.</span>"

/obj/machinery/hologram/holopad/attack_ai(mob/living/silicon/ai/user)
	if (!istype(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj.loc != src.loc)//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(get_turf(src))
	else if(!masters[user])//If there is no hologram, possibly make one.
		activate_holo(user)
	else//If there is a hologram, remove it.
		clear_holo(user)
	return

/obj/machinery/hologram/holopad/proc/activate_holo(mob/living/user)
	if(!operable())//If the projector has power and client eye is on it
		user << "<span class='danger'>ERROR:</span> Unable to project hologram."
		return
	if(user.eyeobj && user.eyeobj.loc == src.loc)
		return
	if(istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		if (AI.holo)
			AI << "<span class='danger'>ERROR:</span> Image feed in progress."
			return
	create_holo(user)//Create one.
	src.visible_message("A holographic image of [user] flicks to life right before your eyes!")
	return

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/hologram/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	if(M)
		for(var/mob/living/master in masters)
			if(!master.say_understands(M, speaking))//The AI will be able to understand most mobs talking through the holopad.
				if(speaking)
					text = speaking.scramble(text)
				else
					text = stars(text)
			var/name_used = M.GetVoice()
			//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
			var/rendered
			if(speaking)
				rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
			else
				rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
			master.show_message(rendered, 2)

/obj/machinery/hologram/holopad/see_emote(mob/living/M, text)
	for(var/mob/living/master in masters)
		var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
		master.show_message(rendered, 2)
	return

/obj/machinery/hologram/holopad/show_message(msg, type, alt, alt_type)
	for(var/mob/living/master in masters)
		var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)
	return

/obj/machinery/hologram/holopad/proc/create_holo(mob/living/A, turf/T = loc)
	var/obj/effect/overlay/hologram = new(T)//Spawn a blank effect at the location.
	if(istype(A,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = A
		hologram.overlays += AI.holo_icon // Add it as an overlay to keep coloration!
		AI.holo = src
	else
		hologram.overlays += make_hologram(A)
	hologram.mouse_opacity = 0//So you can't click on it.
	hologram.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = 1//So space wind cannot drag it.
	hologram.name = "[A.get_visible_name()] (Hologram)"//If someone decides to right click.
	hologram.set_light(2)	//hologram lighting
	hologram.color = color //painted holopad gives coloured holograms
	masters[A] = hologram
	set_light(2)			//pad lighting
	icon_state = "holopad1"
	return 1

/obj/machinery/hologram/holopad/proc/clear_holo(mob/living/user)
	if(istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		if(AI.holo == src)
			AI.holo = null
	qdel(masters[user])//Get rid of user's hologram
	masters -= user //Discard AI from the list of those who use holopad
	if (!masters.len)//If no users left
		set_light(0)			//pad lighting (hologram lighting will be handled automatically since its owner was deleted)
		icon_state = "holopad0"
	return 1

/obj/machinery/hologram/holopad/process()
	for (var/mob/living/silicon/ai/master in masters)
		var/active_ai = (master && !master.incapacitated() && master.client && master.eyeobj)//If there is an AI with an eye attached, it's not incapacitated, and it has a client
		if((stat & NOPOWER) || !active_ai)
			clear_holo(master)
			continue

		if(!(masters[master] in view(src)))
			clear_holo(master)
			continue

		use_power(power_per_hologram)
	return 1

/obj/machinery/hologram/holopad/proc/move_hologram(mob/living/user)
	if(masters[user])
		step_to(masters[user], user.eyeobj) // So it turns.
		var/obj/effect/overlay/H = masters[user]
		H.forceMove(get_turf(user.eyeobj))
		masters[user] = H

		if(!(H in view(src)))
			clear_holo(user)
			return 0

		if((HOLOPAD_MODE == RANGE_BASED && (get_dist(user.eyeobj, src) > holo_range)))
			clear_holo(user)

		if(HOLOPAD_MODE == AREA_BASED)
			var/area/holo_area = get_area(src)
			var/area/hologram_area = get_area(H)
			if(hologram_area != holo_area)
				clear_holo(user)
	return 1

/obj/machinery/hologram/holopad/proc/set_dir_hologram(new_dir, mob/living/user)
	if(masters[user])
		var/obj/effect/overlay/hologram = masters[user]
		hologram.dir = new_dir



/*
 * Hologram
 */

/obj/machinery/hologram
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100

//Destruction procs.
/obj/machinery/hologram/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/machinery/hologram/holopad/Destroy()
	for (var/mob/living/silicon/ai/master in masters)
		clear_holo(master)
	..()

/*
 * Other Stuff: Is this even used?
 */
/obj/machinery/hologram/projector
	name = "hologram projector"
	desc = "It makes a hologram appear...with magnets or something..."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "broadcaster"
	var/obj/machinery/hologram/holopad/pad

/obj/machinery/hologram/projector/attack_hand(var/mob/living/carbon/human/user)
	if(!operable())
		return
	if(alert(user,"Would you like to place a holocall?",,"Yes","No") == "Yes")
		world << "Holocall go."
		var/list/pads = list()
		for(var/obj/machinery/hologram/holopad/H in machines)
			world << "Checking [H] at [H.x] [H.y]."
			world << "It's z is [H.z], station levels are [english_list(using_map.station_levels)]"
			world << "It's [H.operable() ? "" : "in"]operable"
			if((H.z in using_map.station_levels) && H.operable())
				var/area/A = get_area(H)
				world << "Adding [H] in area [A.name]"
				pads["[A.name]"] = H
		world << "Viable pads are now [english_list(pads)]"
		var/padname = input(user, "Which holopad do you want to call?", "Holocall") as anything in pads
		if(padname)
			pad = pads[padname]
			world << "Connecting to [pad] at [pad.x] [pad.y]."
			pad.activate_holo(user)
			user.set_machine(src)
			user.reset_view(pad)

/obj/machinery/hologram/projector/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	for(var/mob/living/master in view(world.view, get_turf(pad)))
		var/rendered
		if(!master.say_understands(M, speaking))//The AI will be able to understand most mobs talking through the holopad.
			if(speaking)
				rendered = speaking.scramble(text)
			else
				rendered = stars(text)
		var/name_used = "Unknown"
		if(M)
			name_used = M.GetVoice()
		//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
		if(speaking)
			rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
		else
			rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
		M.show_message(rendered)

/obj/machinery/hologram/projector/see_emote(mob/living/M, text)
	var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
	pad.visible_message(rendered)

/proc/make_hologram(atom/appear)
	var/image/I = image(appear.icon, appear.icon_state)
	I.overlays = appear.overlays
	I.underlays = appear.underlays
	I.color = list(
			0.30, 0.30, 0.30, 0.0, // Greyscale and reduce the alpha of the icon
			0.59, 0.59, 0.59, 0.0,
			0.11, 0.11, 0.11, 0.0,
			0.00, 0.00, 0.00, 0.5,
			0.00, 0.00, 0.00, 0.0
		)
	var/image/scan = image('icons/effects/effects.dmi', "scanline")
	scan.color = list(
			0.30,0.30,0.30,0.00, // Greyscale the scanline icon too
			0.59,0.59,0.59,0.00,
			0.11,0.11,0.11,0.00,
			0.00,0.00,0.00,1.00,
			0.00,0.00,0.00,0.00
		)
	scan.blend_mode = BLEND_MULTIPLY

	// Combine the mob image and the scanlines into a single KEEP_TOGETHER'd image
	var/image/I2 = image(null)
	I2.underlays += I
	I2.overlays += scan
	I2.appearance_flags = KEEP_TOGETHER
	I2.color = rgb(125, 180, 225) // make it blue!
	return I2
#undef RANGE_BASED
#undef AREA_BASED
#undef HOLOPAD_PASSIVE_POWER_USAGE
#undef HOLOGRAM_POWER_USAGE
