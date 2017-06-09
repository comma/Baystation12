//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	//invisibility = 101

	var/landmark_tag
	//ID of the controller on the shuttle
	var/docking_target = null
	//ID of the controller on the dock side
	var/datum/computer/file/embedded_program/docking/docking_controller

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set.
	var/turf/base_turf

/obj/effect/shuttle_landmark/New()
	..()
	tag = landmark_tag //since tags cannot be set at compile time
	base_area = locate(base_area || world.area)
	name = name + " ([x],[y])"

/obj/effect/shuttle_landmark/initialize()
	if(docking_controller)
		var/docking_tag = docking_controller
		docking_controller = locate(docking_tag)
		if(!istype(docking_controller))
			log_error("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	return TRUE

//Self-naming/numbering ones.
/obj/effect/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"
	var/shuttle_restricted //name of the shuttle, null for generic waypoint

/obj/effect/shuttle_landmark/automatic/New()
	tag = landmark_tag+"-[x]-[y]"
	..()

/obj/effect/shuttle_landmark/automatic/initialize()
	..()
	if(!using_map.use_overmap)
		return
	var/obj/effect/overmap/O = map_sectors["[z]"]
	if(!istype(O))
		return
	if(shuttle_restricted)
		O.restricted_waypoints += src
	else
		O.generic_waypoints  += src