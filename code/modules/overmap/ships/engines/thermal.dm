//Thermal nozzle engine
/datum/ship_engine/thermal
	name = "thermal engine"

/datum/ship_engine/thermal/get_status()
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	return E.get_status()

/datum/ship_engine/thermal/get_thrust()
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	return E.get_thrust()

/datum/ship_engine/thermal/burn()
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	return E.burn()

/datum/ship_engine/thermal/set_thrust_limit(var/new_limit)
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	E.thrust_limit = new_limit

/datum/ship_engine/thermal/get_thrust_limit()
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	return E.thrust_limit

/datum/ship_engine/thermal/is_on()
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	return E.is_on()

/datum/ship_engine/thermal/toggle()
	..()
	var/obj/machinery/atmospherics/unary/engine/E = engine
	E.on = !E.on

//Actual thermal nozzle engine object

/obj/machinery/atmospherics/unary/engine
	name = "engine nozzle"
	desc = "Simple thermal nozzle, uses heated gast to propell the ship."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	opacity = 1
	density = 1
	var/on = 1
	var/thrust_limit = 1	//Value between 1 and 0 to limit the resulting thrust
	var/datum/ship_engine/thermal/controller
	var/fuel_per_burn = 20

/obj/machinery/atmospherics/unary/engine/initialize()
	..()
	controller = new(src)

/obj/machinery/atmospherics/unary/engine/Destroy()
	..()
	controller.die()

/obj/machinery/atmospherics/unary/engine/proc/get_status()
	if(!powered())
		return "Insufficient power to operate."
	if(!check_fuel())
		return "Insufficient fuel for a burn."
	return "Fuel pressure: [round(air_contents.return_pressure()/1000,0.1)] MPa."

/obj/machinery/atmospherics/unary/engine/proc/is_on()
	return on && powered()

/obj/machinery/atmospherics/unary/engine/proc/check_fuel()
	return air_contents.total_moles && (air_contents.get_moles_in_volume(fuel_per_burn * thrust_limit) <= air_contents.total_moles)

/obj/machinery/atmospherics/unary/engine/proc/get_thrust()
	if(!is_on())
		return 0
	if(!check_fuel())
		return 0
	var/used_moles = air_contents.get_moles_in_volume(fuel_per_burn * thrust_limit)
	if(!used_moles)
		return 0
	var/mass = air_contents.get_mass() / air_contents.total_moles * used_moles
	world << "<hr>"
	world << "Using [fuel_per_burn * thrust_limit] L, moles left [air_contents.total_moles]"
	world << "Using [used_moles] moles"
	world << "Fuel mix is: [english_list(air_contents.gas)]"
	world << "T: [air_contents.temperature] K; Pressure: [round(air_contents.return_pressure()/1000,0.1)] MPa."
	world << "Mass: [mass] kg."
	. = round(sqrt(mass * air_contents.return_pressure()/100),0.1)
	return

/obj/machinery/atmospherics/unary/engine/proc/burn()
	if (!is_on())
		return
	if(!check_fuel())
		visible_message(src,"<span class='warning'>[src] coughs once and goes silent!</span>")
		on = !on
		return 0
	var/exhaust_dir = reverse_direction(dir)
	var/datum/gas_mixture/removed = air_contents.remove_volume(fuel_per_burn * thrust_limit)
	var/turf/T = get_step(src,exhaust_dir)
	if(T)
		T.assume_air(removed)
		new/obj/effect/engine_exhaust(T,exhaust_dir,air_contents.temperature)
	return 1

//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	light_color = "#ED9200"
	anchored = 1

/obj/effect/engine_exhaust/New(var/turf/nloc, var/ndir, var/temp)
	..(nloc)
	if(temp > PHORON_MINIMUM_BURN_TEMPERATURE)
		icon_state = "exhaust"
		set_light(5, 2)
	set_dir(ndir)
	nloc.hotspot_expose(temp,125)
	playsound(loc, 'sound/effects/spray.ogg', 50, 1, -1)
	spawn(20)
		qdel(src)